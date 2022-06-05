import React, {
  forwardRef,
  ReactElement,
  useEffect,
  useImperativeHandle,
  useState,
} from 'react';
import {
  ActivityIndicator,
  findNodeHandle,
  NativeModules,
  NativeSyntheticEvent,
  PermissionsAndroid,
  Platform,
  requireNativeComponent,
  StyleSheet,
  Text,
  UIManager,
  View,
  ViewProps,
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
  startCamera(): void;
  stopCamera(): void;
}

interface CardScannerProps extends ViewProps {
  didCardScan?: (props: CardScannerResponse) => void;
  frameColor?: string;
  PermissionCheckingComponent?: ReactElement;
  NotAuthorizedComponent?: ReactElement;
  disabled?: boolean;
  useAppleVision?: boolean;
}

const ComponentName = 'CardScannerView';
const ComponentVisionName = 'CardScannerVision';

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
    useAppleVision,
    ...props
  },
  ref
) => {
  const [viewId, setViewId] = useState<number | null>(null);
  const [isPermissionChecked, setIsPermissionChecked] = useState(false);
  const [isAuthorized, setIsAuthorized] = useState(false);

  const isEnableAppleVision =
    useAppleVision &&
    Platform.OS === 'ios' &&
    parseInt(Platform.Version, 10) >= 13;

  useEffect(() => {
    checkCameraPermission().then((isGranted: boolean) => {
      setIsAuthorized(isGranted);
      setIsPermissionChecked(true);
    });
  }, []);

  useImperativeHandle(
    ref,
    () => {
      const Commands = UIManager.getViewManagerConfig(
        isEnableAppleVision ? ComponentVisionName : ComponentName
      ).Commands;

      const toggleFlashId = getCommandId(Commands.toggleFlash);
      const resetResultId = getCommandId(Commands.resetResult);
      const startCameraId = getCommandId(Commands.startScanCard);
      const stopCameraId = getCommandId(Commands.stopScanCard);

      return {
        toggleFlash() {
          UIManager.dispatchViewManagerCommand(viewId, toggleFlashId, []);
        },
        resetResult() {
          UIManager.dispatchViewManagerCommand(viewId, resetResultId, []);
        },
        startCamera() {
          UIManager.dispatchViewManagerCommand(viewId, startCameraId, []);
        },
        stopCamera() {
          UIManager.dispatchViewManagerCommand(viewId, stopCameraId, []);
        },
      };
    },
    [viewId, isEnableAppleVision]
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

  const CardScannerComponent = isEnableAppleVision
    ? CardScannerVision
    : CardScannerView;

  return (
    <View {...props}>
      {!disabled && (
        <CardScannerComponent
          style={StyleSheet.absoluteFill}
          onDidScanCard={_onDidScanCard}
          ref={(r: any) => {
            setViewId(findNodeHandle(r));
          }}
          frameColor={frameColor}
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
  frameColor?: string;
}

const LINKING_ERROR =
  `The package 'rn-card-scanner' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const CardScannerView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<ScannerNativeProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

const CardScannerVision =
  UIManager.getViewManagerConfig(ComponentVisionName) != null
    ? requireNativeComponent<ScannerNativeProps>(ComponentVisionName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
