# Credit Card Scanner
![npm](https://img.shields.io/npm/dm/rn-card-scanner?logo=npm)

This library provides payment card scanning functionality for your react-native app

![example.gif](example.gif)

- [Installation](#installation)
- [Usage](#usage)
- [Run example project](#run-example-project)
- [Available props](#available-props)
- [Contributing](#contributing)
- [License](#license)
- [Original SDK](#original-sdk)

## Installation

### 1. Install the library

using either Yarn:

```
yarn add rn-card-scanner
```

or npm:

```
npm install --save rn-card-scanner
```

### 2. Link

**React Native 0.60 and above**

[CLI autolink feature](https://github.com/react-native-community/cli/blob/master/docs/autolinking.md) links the module while building the app.

_Note_ For `iOS` using `cocoapods`, run:

```bash
$ cd ios/ && pod install
```

**React Native 0.59 and below**

Run `react-native link rn-card-scanner` to link the rn-card-scanner library.
After following the instructions for your platform to link rn-card-scanner into your project:

### Manual Linking

### iOS installation

<details>
  <summary>iOS details</summary>

### Using [CocoaPods](https://cocoapods.org/)

Add the following to your `Podfile` and run `pod install`:

```ruby
 pod 'RNCardScanner', :path => '../node_modules/rn-card-scanner'
```

</details>

### Android installation

<details>
  <summary>Android details</summary>

Run `react-native link rn-card-scanner` to link the rn-card-scanner library.

#### **android/settings.gradle**

```gradle
include ':reactnativecardscanner'
project(':reactnativecardscanner').projectDir = new File(rootProject.projectDir, '../node_modules/rn-card-scanner/android')
```

#### **android/app/build.gradle**

From version >= 5.0.0, you have to apply these changes:

```diff
dependencies {
   ...
+    implementation project(':reactnativecardscanner')
}
```

#### **android/gradle.properties**

Migrating to AndroidX (needs version >= 5.0.0):

```gradle.properties
android.useAndroidX=true
android.enableJetifier=true
```

#### **Then, in android/app/src/main/java/your/package/MainApplication.java:**

On top, where imports are:

```java
import com.reactnativecardscanner.CardScannerPackage;
```

```java
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.asList(
            new MainReactPackage(),
            new CardScannerPackage()
    );
}
```

</details>

## Usage

```javascript
import CardScanner from 'rn-card-scanner';
```

```js
<CardScanner
  style={{ flex: 1 }}
  didCardScan={(response) => {
    console.log('Card info: ', response);
  }}
/>
```

## Run example project

Running the example project:

1. Checkout this repository.
2. Go to `example` directory and run `yarn` or `npm i`
3. Go to `example/ios` and install Pods with `pod install`
4. Run app

- To run Android app: npx react-native run-android
- To run iOS app: npx react-native run-ios

## Available props

| Prop                              | Description                                                                                                    | Default     | Type                   |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------- | ----------- | ---------------------- |
| **`didCardScan`**                 | This function will be called when the scan is completed and returns the [CreditCard](#creditcard) information. | `undefined` | `Object`               |
| **`frameColor`**                  | Recognizer frame color.                                                                                        | `undefined` | `number or ColorValue` |
| **`PermissionCheckingComponent`** | Show when permission is checking.                                                                              | `undefined` | `ReactElement`         |
| **`NotAuthorizedComponent`**      | Show when permission is not authorized.                                                                        | `undefined` | `ReactElement`         |
| **`disabled`**                    | Disable scanner.                                                                                               | `false` | `boolean`         |

- Includes all React Native [View](https://reactnative.dev/docs/view#props) props.

### CreditCard

An object with the following keys:

- `cardNumber` - Card number.
- `expiryMonth` - Expiry month.
- `expiryYear` - Expiry year.
- `holderName` - Card holder name.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

## Original SDK

[Android](https://github.com/faceterteam/PayCards_Android) - [iOS](https://github.com/faceterteam/PayCards_iOS)
