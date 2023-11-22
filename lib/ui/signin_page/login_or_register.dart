import 'package:AppleYonsei/ui/customer_page/customer_home_page.dart';
import 'package:AppleYonsei/ui/signin_page/register_page.dart';
import 'package:AppleYonsei/ui/signin_page/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/customer_page/customer_home_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initially show login page
  bool showLoginPage = true;

  //toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage =! showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return SigninPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
