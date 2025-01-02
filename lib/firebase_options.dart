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
    apiKey: 'AIzaSyBzRSUqStgPo1sL8m3QeOiMpNA4YPDqlsg',
    appId: '1:667596749825:web:5f02550f1affe3df4d9400',
    messagingSenderId: '667596749825',
    projectId: 'katyani',
    authDomain: 'katyani.firebaseapp.com',
    storageBucket: 'katyani.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDd1l62FM4fqtGtbe9_p6jwef3gvwAEYPo',
    appId: '1:667596749825:android:3dff5ca8cf75cba64d9400',
    messagingSenderId: '667596749825',
    projectId: 'katyani',
    storageBucket: 'katyani.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5LTfHrAKUJ-1fkxI8yv31ajldOQgFz7U',
    appId: '1:667596749825:ios:a1dbabe654be45fe4d9400',
    messagingSenderId: '667596749825',
    projectId: 'katyani',
    storageBucket: 'katyani.firebasestorage.app',
    iosBundleId: 'com.example.katyani',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5LTfHrAKUJ-1fkxI8yv31ajldOQgFz7U',
    appId: '1:667596749825:ios:a1dbabe654be45fe4d9400',
    messagingSenderId: '667596749825',
    projectId: 'katyani',
    storageBucket: 'katyani.firebasestorage.app',
    iosBundleId: 'com.example.katyani',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBzRSUqStgPo1sL8m3QeOiMpNA4YPDqlsg',
    appId: '1:667596749825:web:6c4ad19148480e7e4d9400',
    messagingSenderId: '667596749825',
    projectId: 'katyani',
    authDomain: 'katyani.firebaseapp.com',
    storageBucket: 'katyani.firebasestorage.app',
  );
}
