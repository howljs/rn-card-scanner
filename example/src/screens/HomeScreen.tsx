import React from 'react';
import {
  Image,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { Images } from '../assets';
import { useNavigation, type NavigationProp } from '@react-navigation/native';
import type { RootStackRoutes } from '../types';

const HomeScreen = () => {
  const navigation = useNavigation<NavigationProp<RootStackRoutes>>();
  const _onPressScan = (useAppleVision: boolean) => {
    navigation.navigate('Recognizer', { useAppleVision: useAppleVision });
  };

  return (
    <View style={styles.container}>
      <Image
        source={Images().creditCard}
        style={styles.creditCard}
        resizeMode="contain"
      />
      <Text style={styles.header}>Credit card scanner</Text>
      <Text style={styles.description}>Add your card by scanning it</Text>
      <TouchableOpacity
        activeOpacity={0.6}
        style={styles.scanBtn}
        onPress={() => _onPressScan(false)}
      >
        <Text style={styles.scanText}>Scan card</Text>
      </TouchableOpacity>
      {Platform.OS === 'ios' && (
        <TouchableOpacity
          activeOpacity={0.6}
          style={styles.scanBtn}
          onPress={() => _onPressScan(true)}
        >
          <Text style={styles.scanText}>Scan card (Use Apple Vision)</Text>
        </TouchableOpacity>
      )}
    </View>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
  },
  creditCard: { width: 260 },
  header: { fontSize: 24, fontWeight: 'bold', marginBottom: 16 },
  description: { fontSize: 16 },
  scanBtn: {
    paddingVertical: 16,
    paddingHorizontal: 24,
    backgroundColor: '#FF5F00',
    marginTop: 32,
    borderRadius: 10,
  },
  scanText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
});
