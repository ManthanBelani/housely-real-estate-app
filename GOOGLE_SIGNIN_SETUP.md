# Google Sign-In Setup Instructions

To fix the "PlatformException sign_in_failed" error, please follow these steps:

## 1. Configure SHA-1 Fingerprint in Firebase Console

For development:
```bash
# Generate debug SHA-1 (for testing)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For production:
```bash
# If you have a release keystore, use:
keytool -list -v -keystore /path/to/your/keystore.jks -alias your_alias_name
```

Then add the SHA-1 fingerprint to your Firebase Console:
1. Go to Firebase Console → Project Settings → General
2. Scroll down to "SHA certificate fingerprints" section
3. Click "Add Fingerprint" and paste your SHA-1

## 2. Enable Google Sign-In in Firebase Authentication

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable "Google" provider
3. Save the configuration

## 3. Verify google-services.json

Make sure your `android/app/google-services.json` file is properly configured and contains the correct package name and configurations.

## 4. Android Configuration

Make sure your AndroidManifest.xml includes the necessary configurations (already added in this project).

## 5. For iOS Configuration

For iOS, update the Info.plist file with your actual reversed client ID:
1. Go to Firebase Console → Project Settings → General
2. Find your iOS app config and get the "iOS URL scheme"
3. Replace the placeholder in `/ios/Runner/Info.plist`

## Common Issues and Solutions:

- **"sign_in_failed" error**: Usually caused by missing SHA-1 fingerprint in Firebase Console
- **App crashes after sign-in**: Make sure Google Play Services are updated on the device
- **"This app is not authorized to use Google Sign-In"**: Check that the package name matches your Firebase project configuration

## Testing

After completing the setup, run:
```bash
flutter clean
flutter pub get
flutter run
```