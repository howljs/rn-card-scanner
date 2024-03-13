import {
  useNavigation,
  useRoute,
  type NavigationProp,
  type RouteProp,
} from '@react-navigation/native';
import React, { useState } from 'react';
import { Alert, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { TextInput } from '../components';
import type { RootStackRoutes } from '../types';

const ResultScreen = () => {
  const navigation = useNavigation<NavigationProp<RootStackRoutes>>();
  const route = useRoute<RouteProp<RootStackRoutes, 'Result'>>();

  const [holderName, setHolderName] = useState(route.params?.holderName);
  const [cardNumber, setCardNumber] = useState(route.params?.cardNumber);
  const [expiration, setExpiration] = useState(
    route.params?.expiryMonth &&
      route.params?.expiryYear &&
      `${route.params?.expiryMonth}/${route.params?.expiryYear}`
  );
  const [cvv, setCvv] = useState('');

  const _onPressSubmit = () => {
    Alert.alert('Success');
    navigation.navigate('Home');
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.textInput}
        label="Cardholder Name"
        value={holderName}
        onChangeText={(text) => setHolderName(text)}
      />
      <TextInput
        style={styles.textInput}
        label="Card Number"
        value={cardNumber}
        onChangeText={(text) => setCardNumber(text)}
      />
      <View style={styles.row}>
        <TextInput
          style={[styles.textInput, styles.col, styles.mr24]}
          label="Expiration Date"
          value={expiration}
          onChangeText={(text) => setExpiration(text)}
        />
        <TextInput
          style={[styles.textInput, styles.col]}
          label="Security Code"
          value={cvv}
          onChangeText={(text) => setCvv(text)}
        />
      </View>
      <TouchableOpacity style={styles.addCardBtn} onPress={_onPressSubmit}>
        <Text style={styles.addCardText}>Add card</Text>
      </TouchableOpacity>
    </View>
  );
};

export default ResultScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    paddingHorizontal: 16,
  },
  textInput: {
    marginTop: 24,
  },
  mr24: { marginRight: 24 },
  row: { flexDirection: 'row', marginBottom: 36 },
  col: { flex: 1 },
  addCardBtn: {
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 10,
    backgroundColor: '#293462',
  },
  addCardText: {
    fontSize: 18,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#FFFFFF',
  },
});
