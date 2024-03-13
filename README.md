# Credit Card Scanner

[![Version][npm-shield]][npm-link]
[![PayPal_Me][paypal-me-shield]][paypal-me]
[![ko-fi][ko-fi-shield]][ko-fi-profile]

This library provides payment card scanning functionality for your react-native app

![example.gif](example.gif)

- [Credit Card Scanner](#credit-card-scanner)
  - [Installation](#installation)
    - [1. Install the library](#1-install-the-library)
    - [2. Link (iOS only)](#2-link-ios-only)
    - [3. Permissions (iOS only)](#3-permissions-ios-only)
  - [Usage](#usage)
  - [Run example project](#run-example-project)
  - [Available props](#available-props)
  - [Available methods](#available-methods)
    - [CreditCard](#creditcard)
  - [Troubleshooting](#troubleshooting)
    - [`Undefined symbols for architecture x86_64` on iOS](#undefined-symbols-for-architecture-x86_64-on-ios)
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

### 2. Link (iOS only)

If you're on a Mac and developing for iOS, you need to install the pods (via [Cocoapods](https://cocoapods.org)) to complete the linking.

```bash
$ npx pod-install ios
```

### 3. Permissions (iOS only)

Add the following keys to your `Info.plist` file, located in `<project-root>/ios/YourAppName/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Allow access to your camera to scan credit card</string>
```

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

| Prop                              | Description                                                                                                                 | Default     | Type                   |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------- | ---------------------- |
| **`didCardScan`**                 | This function will be called when the scan is completed and returns the [CreditCard](#creditcard) information.              | `undefined` | `Object`               |
| **`frameColor`**                  | Recognizer frame color.                                                                                                     | `undefined` | `number or ColorValue` |
| **`PermissionCheckingComponent`** | Show when permission is checking.                                                                                           | `undefined` | `ReactElement`         |
| **`NotAuthorizedComponent`**      | Show when permission is not authorized.                                                                                     | `undefined` | `ReactElement`         |
| **`disabled`**                    | Disable scanner.                                                                                                            | `undefined` | `boolean`              |
| **`useAppleVision`**              | Use [Apple's Vision Framework](https://developer.apple.com/documentation/vision) to scan credit card when iOS version >= 13 | `undefined` | `boolean`              |

- Includes all React Native [View](https://reactnative.dev/docs/view#props) props.

## Available methods

```js
const cardScannerRef = useRef(null)

<CardScanner
  //Other props
  ref={cardScannerRef}
/>

//Ex: Toggle flash on and off
onPress={() => cardScannerRef.current.toggleFlash()}
```

| Method            | Description              |
| ----------------- | ------------------------ |
| **`toggleFlash`** | Toggle flash on and off  |
| **`resetResult`** | Reset recognizer result. |
| **`startCamera`** | Start recognizer         |
| **`stopCamera`**  | Stop recognizer.         |

### CreditCard

An object with the following keys:

- `cardNumber` - Card number.
- `expiryMonth` - Expiry month.
- `expiryYear` - Expiry year.
- `holderName` - Card holder name.

## Troubleshooting

### `Undefined symbols for architecture x86_64` on iOS

While building your iOS project, you may see a `Undefined symbols for architecture x86_64` error. This is caused by `react-native init` template configuration that is not fully compatible with Swift.

```
Undefined symbols for architecture x86_64:
    "_swift_FORCE_LOAD...
    ld: symbol(s) not found for architecture x86_64
```

Follow these steps to resolve this:
- Open your project via Xcode.
- Create a new Swift file to the project (File > New > File > Swift), give it any name (e.g. `File.swift`) and answer "yes" when Xcode asks you if you want to "Create Bridging Header"
- Clean build and run app

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

## Original SDK

[Android](https://github.com/faceterteam/PayCards_Android) - [iOS](https://github.com/faceterteam/PayCards_iOS)

[npm-shield]: https://img.shields.io/npm/v/rn-card-scanner
[ko-fi-shield]: https://img.shields.io/static/v1.svg?label=%20&message=ko-fi&logo=ko-fi&color=13C3FF
[paypal-me-shield]: https://img.shields.io/static/v1.svg?label=%20&message=PayPal.Me&logo=paypal
[paypal-me]: https://www.paypal.me/j2teamlh
[ko-fi-profile]: https://ko-fi.com/W7W6G75FH
[npm-link]: https://www.npmjs.com/package/rn-card-scanner