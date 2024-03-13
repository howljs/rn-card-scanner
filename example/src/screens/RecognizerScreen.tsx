import {
  useIsFocused,
  useNavigation,
  type NavigationProp,
  useRoute,
  type RouteProp,
} from '@react-navigation/native';
import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import CardScanner, { type CardScannerResponse } from 'rn-card-scanner';
import type { RootStackRoutes } from '../types';

const RecognizerScreen = () => {
  const isFocused = useIsFocused();
  const navigation = useNavigation<NavigationProp<RootStackRoutes>>();
  const route = useRoute<RouteProp<RootStackRoutes, 'Recognizer'>>();
  const { bottom: safeBottom } = useSafeAreaInsets();

  const _onPressAddManually = (props?: CardScannerResponse) => {
    navigation.navigate('Result', props);
  };

  return (
    <View style={styles.container}>
      <CardScanner
        disabled={!isFocused}
        style={styles.scanner}
        didCardScan={_onPressAddManually}
        useAppleVision={route.params.useAppleVision}
      />
      <TouchableOpacity
        onPress={() => _onPressAddManually()}
        style={[styles.addBtn, { marginBottom: safeBottom + 16 }]}
      >
        <Text style={styles.addText}>Add manually</Text>
      </TouchableOpacity>
    </View>
  );
};

export default RecognizerScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    paddingHorizontal: 16,
    paddingVertical: 24,
  },
  scanner: {
    flexGrow: 1,
    borderRadius: 10,
    overflow: 'hidden',
    marginBottom: 32,
    backgroundColor: '#CCCCCC',
  },
  addBtn: {
    borderWidth: 1,
    borderRadius: 10,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderColor: '#293462',
    alignSelf: 'center',
  },
  addText: { fontSize: 16, color: '#293462', textAlign: 'center' },
});
