import React, {
  forwardRef,
  ReactElement,
  useEffect,
  useImperativeHandle,
  useRef,
  useState,
} from 'react';
import {
  ActivityIndicator,
  ColorValue,
  findNodeHandle,
  NativeSyntheticEvent,
  PermissionsAndroid,
  Platform,
  processColor,
  ProcessedColorValue,
  requireNativeComponent,
  StyleSheet,
  Text,
  UIManager,
  View,
  ViewProps,
  NativeModules,
} from 'react-native';

export interface CardScannerResponse {
  cardNumber?: string;
  expiryYear?: string;
  expiryMonth?: string;
  holderName?: string;
}

export interface CardScannerHandle {
  toggleFlash(): void;
  resetResult(): void;
}

interface CardScannerProps extends ViewProps {
  didCardScan?: (props: CardScannerResponse) => void;
  frameColor?: number | ColorValue;
  PermissionCheckingComponent?: ReactElement;
  NotAuthorizedComponent?: ReactElement;
  disabled?: boolean;
}

const CardScanner: React.ForwardRefRenderFunction<
  CardScannerHandle,
  CardScannerProps
> = (
  {
    didCardScan,
    frameColor,
    PermissionCheckingComponent,
    NotAuthorizedComponent,
    disabled,
    ...props
  },
  ref
) => {
  const scannerRef = useRef(null);
  const [isPermissionChecked, setIsPermissionChecked] = useState(false);
  const [isAuthorized, setIsAuthorized] = useState(false);

  useEffect(() => {
    checkCameraPermission().then((isGranted: boolean) => {
      setIsAuthorized(isGranted);
      setIsPermissionChecked(true);
    });
  }, []);

  useImperativeHandle(
    ref,
    () => {
      const viewId = findNodeHandle(scannerRef.current);
      const Commands =
        UIManager.getViewManagerConfig('CardScannerView').Commands;

      const toggleFlashId = getCommandId(Commands.toggleFlash);
      const resetResultId = getCommandId(Commands.resetResult);

      return {
        toggleFlash() {
          UIManager.dispatchViewManagerCommand(viewId, toggleFlashId, []);
        },
        resetResult() {
          UIManager.dispatchViewManagerCommand(viewId, resetResultId, []);
        },
      };
    },
    []
  );

  const _onDidScanCard = (res: NativeSyntheticEvent<CardScannerResponse>) => {
    didCardScan && didCardScan(res.nativeEvent);
  };

  if (!isPermissionChecked) {
    if (PermissionCheckingComponent) {
      return PermissionCheckingComponent;
    }

    return (
      <View style={styles.authorization}>
        <ActivityIndicator color="#293462" />
      </View>
    );
  }

  if (!isAuthorized) {
    if (NotAuthorizedComponent) {
      return NotAuthorizedComponent;
    }

    return (
      <View style={styles.authorization}>
        <Text style={styles.authorizationText}>
          Need "Camera Permission" to scan your card
        </Text>
      </View>
    );
  }

  return (
    <View {...props}>
      {!disabled && (
        <CardScannerView
          style={StyleSheet.absoluteFill}
          onDidScanCard={_onDidScanCard}
          ref={scannerRef}
          frameColor={processColor(frameColor)}
        />
      )}
    </View>
  );
};

export default forwardRef(CardScanner);

const styles = StyleSheet.create({
  authorization: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  authorizationText: { textAlign: 'center', padding: 16 },
});

const checkCameraPermission = async () => {
  try {
    let hasCameraPermissions = false;
    if (Platform.OS === 'android') {
      const permissionStatus = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.CAMERA
      );
      hasCameraPermissions =
        permissionStatus === PermissionsAndroid.RESULTS.GRANTED;
    } else {
      const permissionStatus =
        await NativeModules.CardScanner.requestPermission();
      hasCameraPermissions = permissionStatus.status === 'granted';
    }
    return hasCameraPermissions;
  } catch (error) {
    return false;
  }
};

const getCommandId = (commandId: number) =>
  Platform.select<string | number>({
    android: `${commandId}`,
    default: commandId,
  });

interface ScannerNativeProps extends ViewProps {
  ref: any;
  onDidScanCard: (props: NativeSyntheticEvent<CardScannerResponse>) => void;
  frameColor: ProcessedColorValue | null | undefined;
}

const LINKING_ERROR =
  `The package 'rn-card-scanner' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const CardScannerView =
  UIManager.getViewManagerConfig('CardScannerView') != null
    ? requireNativeComponent<ScannerNativeProps>('CardScannerView')
    : () => {
        throw new Error(LINKING_ERROR);
      };
