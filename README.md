# ALTCHA Flutter Widget

The `AltchaWidget` is a CAPTCHA-like Flutter component that provides a secure, privacy-friendly way to verify that a user is human—without annoying them. It uses a cryptographic proof-of-work mechanism combined with an optional code challenge, making it resilient against bots and spam.

ALTCHA is an open-source alternative to traditional CAPTCHA, designed to be fast, accessible, and privacy-respecting.

For more information and documentation, visit [altcha.org](https://altcha.org).

## Features

- Native Flutter widget – no WebView required
- Privacy-friendly, CAPTCHA-like verification
- Supports image and audio code challenge with ALTCHA Sentinel (adaptive CAPTCHA)
- Localizations support

## Screenshots

<div>
  <img
    src="https://raw.githubusercontent.com/altcha-org/altcha-flutter/refs/heads/main/assets/images/altcha-light.png"
    alt="ALTCHA Widget in Light theme."
    width="200">
  <img
    src="https://raw.githubusercontent.com/altcha-org/altcha-flutter/refs/heads/main/assets/images/altcha-light-code.png"
    alt="ALTCHA Widget in Light theme with Code Challenge."
    width="200">
  <img
    src="https://raw.githubusercontent.com/altcha-org/altcha-flutter/refs/heads/main/assets/images/altcha-dark.png"
    alt="ALTCHA Widget in Dark theme."
    width="200">
  <img
    src="https://raw.githubusercontent.com/altcha-org/altcha-flutter/refs/heads/main/assets/images/altcha-dark-code.png"
    alt="ALTCHA Widget in Dark theme with Code Challenge."
    width="200">
</div>

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  altcha_widget:
    git:
      url: https://github.com/altcha-org/altcha-flutter.git
````

Or, if published on pub.dev:

```yaml
dependencies:
  altcha_widget: ^1.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

```dart
import 'package:altcha_widget/widget.dart';
```

```dart
AltchaWidget(
  challengeUrl: 'https://api.example.com/altcha/challenge',
  debug: true,
  onVerified: (payload) {
    // Send the payload to your backend
    print('Payload: $payload');
  },
)
```

## Parameters

One of the `challengeUrl` or `challengeJson` is required. Receive the ALTCHA payload, that you send to the server, via `onVerified`.

| Name                   | Type                                      | Description                                    |
| ---------------------- | ----------------------------------------- | ---------------------------------------------- |
| `challengeUrl`         | `String?`                                 | URL to fetch the challenge JSON                |
| `challengeJson`        | `Map<String, dynamic>?`                   | Challenge object provided directly             |
| `verifyUrl`            | `String?`                                 | Server endpoint to verify the solution         |
| `onFailed`             | `ValueChanged<Object>?`                   | Called with an exception object on verification failure |
| `onVerified`           | `ValueChanged<String>?`                   | Called with encoded payload after verification |
| `onServerVerification` | `ValueChanged<AltchaServerVerification>?` | Called with server verification result         |
| `delay`                | `int?`                                    | Optional delay before solving (ms)             |
| `debug`                | `bool`                                    | Enable verbose logging                         |
| `hideLogo`             | `bool?`                                   | Hide the ALTCHA logo                           |
| `hideFooter`           | `bool?`                                   | Hide the footer text                           |
| `httpClient`           | `http.Client?`                            | Custom HTTP client (optional)                  |
| `httpHeaders`          | `Map<String, String>?`                    | Custom HTTP headers (optional)                 |

## Localization

To support different languages, include `AltchaLocalizationsDelegate`:

```dart
import 'package:altcha_widget/localizations.dart';
```

```dart
return MaterialApp(
  localizationsDelegates: [
    AltchaLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ],
  ...
);
```

You can also override or add your own translations using `AltchaLocalizationsDelegate(customTranslations)`:

```dart
return MaterialApp(
  localizationsDelegates: [
    AltchaLocalizationsDelegate(
      customTranslations: {
        'en': {
          // Define translations keys here
          'label': 'I am human',
        },
      },
    ),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  ...
);
```

## Example App

```bash
cd example/
flutter run
```

## License

MIT License
