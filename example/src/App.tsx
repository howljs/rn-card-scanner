import type { CardScannerResponse } from 'rn-card-scanner';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import React from 'react';
import { LogBox } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { Home, Recognizer, Result } from './screens';

LogBox.ignoreLogs(['ViewPropTypes']);

export type RootStackRoutes = {
  Home: undefined;
  Recognizer: undefined;
  Result?: CardScannerResponse;
};

const Stack = createNativeStackNavigator<RootStackRoutes>();

export default function App() {
  return (
    <SafeAreaProvider>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen
            name="Home"
            component={Home}
            options={{ headerShown: false }}
          />
          <Stack.Screen name="Recognizer" component={Recognizer} />
          <Stack.Screen name="Result" component={Result} />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}
