import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/screens/splashScreen.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'WixMadeforDisplay'),
    home: SplashScreen(),
  ));
}

// initFirebase() async {
//   await Firebase.initializeApp();
// }
