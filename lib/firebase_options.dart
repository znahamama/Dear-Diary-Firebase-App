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
    apiKey: 'AIzaSyD2MpuQArb_ndHYRvcknPTo7zTORCvsNqk',
    appId: '1:299395216236:android:b92e1aef800c455312f949',
    messagingSenderId: '299395216236',
    projectId: 'deardiary-ae52b',
    storageBucket: 'deardiary-ae52b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXki-E02UMQukioO4zsZftmB1t-zGx8KU',
    appId: '1:299395216236:ios:f5db0da9d1ea50d612f949',
    messagingSenderId: '299395216236',
    projectId: 'deardiary-ae52b',
    storageBucket: 'deardiary-ae52b.firebasestorage.app',
    androidClientId: '299395216236-kpf6k6ei0oep0ib08fucnmkvubfgv498.apps.googleusercontent.com',
    iosClientId: '299395216236-ldkucevrh8o6oe8t7gd2nahbf62h0552.apps.googleusercontent.com',
    iosBundleId: 'com.example.deardiaryImg',
  );

}