// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAi_s01lorl3UheOb8_Zyec3HvPYO6VX6c',
    appId: '1:1060919755818:android:03fd9e4926aae636516f53',
    messagingSenderId: '1060919755818',
    projectId: 'agap-f4c32',
    databaseURL: 'https://agap-f4c32-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'agap-f4c32.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNSu7WKHH8YKM4Gg2iN-cE8JVyEPGYNY0',
    appId: '1:1060919755818:ios:24919809981a5b06516f53',
    messagingSenderId: '1060919755818',
    projectId: 'agap-f4c32',
    databaseURL: 'https://agap-f4c32-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'agap-f4c32.appspot.com',
    iosClientId: '1060919755818-ned0al1qul447qe787j8ohlm3s7rofm1.apps.googleusercontent.com',
    iosBundleId: 'com.rabelen.agapMobileV01',
  );
}
