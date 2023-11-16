import 'package:admin/constaints/theme.dart';
import 'package:admin/firebase_helper/firebase_options.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: HomePage(),
      ),
    );
  }
}
