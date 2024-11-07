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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCUiy5cCwShTvgJ0mPhZ9VPmGhDYBttKaM',
    appId: '1:742869217601:web:3ea47abebea0cd6bef71c0',
    messagingSenderId: '742869217601',
    projectId: 'fir-project13-69179',
    authDomain: 'fir-project13-69179.firebaseapp.com',
    storageBucket: 'fir-project13-69179.firebasestorage.app',
    measurementId: 'G-W2JRH7V30R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe1St2qoQVi4Jviyi41jtRDPGYw6gyCFE',
    appId: '1:742869217601:android:35765ab85791ac7fef71c0',
    messagingSenderId: '742869217601',
    projectId: 'fir-project13-69179',
    storageBucket: 'fir-project13-69179.firebasestorage.app',
  );
}
