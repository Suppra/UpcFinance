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
    apiKey: 'AIzaSyDlIMBNrN5qO-wKINLKqZNcI-W8XfpHe3I',
    appId: '1:1064502873396:web:5e10d1f3580c75e3b5e961',
    messagingSenderId: '1064502873396',
    projectId: 'upcfinance-a4c68',
    authDomain: 'upcfinance-a4c68.firebaseapp.com',
    storageBucket: 'upcfinance-a4c68.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPF_Kh_F1ucezwHlbDptwXo_LQjS_ypWM',
    appId: '1:1064502873396:android:f5915d8f1796075ab5e961',
    messagingSenderId: '1064502873396',
    projectId: 'upcfinance-a4c68',
    storageBucket: 'upcfinance-a4c68.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHaqV4PFTZf8s8dW247quKIaRlrg71ZvU',
    appId: '1:1064502873396:ios:be51d925c50c2610b5e961',
    messagingSenderId: '1064502873396',
    projectId: 'upcfinance-a4c68',
    storageBucket: 'upcfinance-a4c68.appspot.com',
    iosBundleId: 'com.example.bovinos',
  );
}
