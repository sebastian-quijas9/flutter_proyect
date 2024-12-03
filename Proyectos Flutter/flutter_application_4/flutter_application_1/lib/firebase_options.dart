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
    apiKey: 'AIzaSyAjYKkw8QqMPM3WhHGr2gI7c26eycla9GE',
    appId: '1:586329157766:web:dbece003c66077299c2107',
    messagingSenderId: '586329157766',
    projectId: 'blog-asiarobotica',
    authDomain: 'blog-asiarobotica.firebaseapp.com',
    storageBucket: 'blog-asiarobotica.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAD3Uav4AX3RLOw2yIJZkbHo4Fb-2JekIY',
    appId: '1:586329157766:android:55192cc5d0a05beb9c2107',
    messagingSenderId: '586329157766',
    projectId: 'blog-asiarobotica',
    storageBucket: 'blog-asiarobotica.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjWEYvEgQo3cs66PkJeHS6tvAg6RgHNx8',
    appId: '1:586329157766:ios:9dea28b691f44d989c2107',
    messagingSenderId: '586329157766',
    projectId: 'blog-asiarobotica',
    storageBucket: 'blog-asiarobotica.appspot.com',
    iosClientId: '586329157766-q5k3u7k6oeu5vvhs29qjqu6a1vus2c6f.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjWEYvEgQo3cs66PkJeHS6tvAg6RgHNx8',
    appId: '1:586329157766:ios:cb55525b794a650d9c2107',
    messagingSenderId: '586329157766',
    projectId: 'blog-asiarobotica',
    storageBucket: 'blog-asiarobotica.appspot.com',
    iosClientId: '586329157766-vl6751crpucpbg2afkdbs6nc4fb0af98.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
