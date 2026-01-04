# pwa-android

Android project scaffold that loads `pwa/index.html` from workspace root into a WebView.

How to use:
1. Ensure this folder `pwa-android` is in the same workspace root that contains `pwa/` and `logo.png`.
2. Open `pwa-android` in Android Studio.
3. Android Studio will sync Gradle; build or run on a device/emulator.
   - The app loads `file:///android_asset/pwa/index.html`.
4. If `logo.png` exists in workspace root, the Gradle preBuild copy task will copy it into mipmap folders as `ic_launcher.png`.
