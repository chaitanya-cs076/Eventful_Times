// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBlFslMmuAgkTF2sBKjYmfnVv_x1FzPpz8',
    appId: '1:1033594851653:web:8dc565a9748086ab686e2c',
    messagingSenderId: '1033594851653',
    projectId: 'emailpasswordauth-c39bb',
    authDomain: 'emailpasswordauth-c39bb.firebaseapp.com',
    storageBucket: 'emailpasswordauth-c39bb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6FMxclLL5gmx7b8Fm08orwQCwlZTOCq8',
    appId: '1:1033594851653:android:12b60e410f3f2449686e2c',
    messagingSenderId: '1033594851653',
    projectId: 'emailpasswordauth-c39bb',
    storageBucket: 'emailpasswordauth-c39bb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALbGzJ1ea1ojajtf4_bpsGd8z3b7qBd3Q',
    appId: '1:1033594851653:ios:4fc99ee4f63daef0686e2c',
    messagingSenderId: '1033594851653',
    projectId: 'emailpasswordauth-c39bb',
    storageBucket: 'emailpasswordauth-c39bb.appspot.com',
    iosBundleId: 'com.example.eventManagemet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyALbGzJ1ea1ojajtf4_bpsGd8z3b7qBd3Q',
    appId: '1:1033594851653:ios:4fc99ee4f63daef0686e2c',
    messagingSenderId: '1033594851653',
    projectId: 'emailpasswordauth-c39bb',
    storageBucket: 'emailpasswordauth-c39bb.appspot.com',
    iosBundleId: 'com.example.eventManagemet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlFslMmuAgkTF2sBKjYmfnVv_x1FzPpz8',
    appId: '1:1033594851653:web:e438a845914517f3686e2c',
    messagingSenderId: '1033594851653',
    projectId: 'emailpasswordauth-c39bb',
    authDomain: 'emailpasswordauth-c39bb.firebaseapp.com',
    storageBucket: 'emailpasswordauth-c39bb.appspot.com',
  );
}
