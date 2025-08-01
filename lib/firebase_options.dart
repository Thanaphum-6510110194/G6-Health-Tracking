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
    apiKey: 'AIzaSyDG76B7oZpJYZPmuyqi35rFShX290PlKDc',
    appId: '1:594641474846:web:623a72087b75a07014650f',
    messagingSenderId: '594641474846',
    projectId: 'database-health-ad9b2',
    authDomain: 'database-health-ad9b2.firebaseapp.com',
    storageBucket: 'database-health-ad9b2.firebasestorage.app',
    measurementId: 'G-CMFCM1V31C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC73F1UW8nQ_JgfHFRqPgWebnToeQw0aAQ',
    appId: '1:594641474846:android:e103d49fe65a1e7314650f',
    messagingSenderId: '594641474846',
    projectId: 'database-health-ad9b2',
    storageBucket: 'database-health-ad9b2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkEJToXqX75dEe9sA0avl-vIgv__Py7H0',
    appId: '1:594641474846:ios:8d67a47c305c6c2714650f',
    messagingSenderId: '594641474846',
    projectId: 'database-health-ad9b2',
    storageBucket: 'database-health-ad9b2.firebasestorage.app',
    iosBundleId: 'com.example.healthTracking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkEJToXqX75dEe9sA0avl-vIgv__Py7H0',
    appId: '1:594641474846:ios:8d67a47c305c6c2714650f',
    messagingSenderId: '594641474846',
    projectId: 'database-health-ad9b2',
    storageBucket: 'database-health-ad9b2.firebasestorage.app',
    iosBundleId: 'com.example.healthTracking',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDG76B7oZpJYZPmuyqi35rFShX290PlKDc',
    appId: '1:594641474846:web:6ead304743601f5c14650f',
    messagingSenderId: '594641474846',
    projectId: 'database-health-ad9b2',
    authDomain: 'database-health-ad9b2.firebaseapp.com',
    storageBucket: 'database-health-ad9b2.firebasestorage.app',
    measurementId: 'G-67371TQW01',
  );
}
