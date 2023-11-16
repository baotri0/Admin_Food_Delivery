import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '',
        apiKey: '',
        projectId: '',
        messagingSenderId: '',
        iosBundleId: '',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:611495139447:android:e25ab72b2ab22cf6474e72',
        apiKey: 'AIzaSyC3M7iGx2L5V3uBDf6YXfora9ujOuzu-Kk',
        projectId: 'food-order-delivery-app-4af80',
        messagingSenderId: '611495139447',
        storageBucket: "food-order-delivery-app-4af80.appspot.com",
      );
    }
  }
}
