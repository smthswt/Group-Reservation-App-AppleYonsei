import 'package:AppleYonsei/ui/login_page/login_page.dart';
import 'package:AppleYonsei/ui/signin_page/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/customer_page/customer_home_page.dart';
import 'package:AppleYonsei/ui/signin_page/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppleYonseiApp());
}

class AppleYonseiApp extends StatelessWidget {
  const AppleYonseiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Reservation App for Yonseian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // routes: routes,
      home: AuthPage(),
      // home: const LoginPage(isShrink: false),
      // home: const MyHomePage(title: 'Apple Yonsei Group Reservation'),
    );
  }
}



























