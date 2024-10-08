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
    apiKey: 'AIzaSyDXYAKkeh34b1NCnziNnb2P0sNSaeSgLBM',
    appId: '1:78950313539:web:11c03a35f2ed46fd23eef6',
    messagingSenderId: '78950313539',
    projectId: 'testdb-9897c',
    authDomain: 'testdb-9897c.firebaseapp.com',
    storageBucket: 'testdb-9897c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzWMI1GwJIuEEfkCONrvJjlYNDr0SHjXc',
    appId: '1:78950313539:android:1c1579462b5eff5323eef6',
    messagingSenderId: '78950313539',
    projectId: 'testdb-9897c',
    storageBucket: 'testdb-9897c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbYoSNwsnndMvy5xjNXKp1-YLpJjFQISQ',
    appId: '1:78950313539:ios:0c7964362b6f5a8323eef6',
    messagingSenderId: '78950313539',
    projectId: 'testdb-9897c',
    storageBucket: 'testdb-9897c.appspot.com',
    iosBundleId: 'com.example.shiftManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbYoSNwsnndMvy5xjNXKp1-YLpJjFQISQ',
    appId: '1:78950313539:ios:0c7964362b6f5a8323eef6',
    messagingSenderId: '78950313539',
    projectId: 'testdb-9897c',
    storageBucket: 'testdb-9897c.appspot.com',
    iosBundleId: 'com.example.shiftManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDYqhlOB9WXXJp_U6dRQWRdQtZPk-0naWM',
    appId: '1:78950313539:web:6dc1ae7cca0e488923eef6',
    messagingSenderId: '78950313539',
    projectId: 'testdb-9897c',
    authDomain: 'testdb-9897c.firebaseapp.com',
    storageBucket: 'testdb-9897c.appspot.com',
  );
}
