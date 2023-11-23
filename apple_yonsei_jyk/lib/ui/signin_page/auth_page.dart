import 'package:AppleYonsei/ui/customer_page/customer_home_page.dart';
import 'package:AppleYonsei/ui/enterprise_page/enterprise_home_page.dart';
import 'package:AppleYonsei/ui/signin_page/card_page.dart';
import 'package:AppleYonsei/ui/signin_page/enterprise_reservation_page.dart';
import 'package:AppleYonsei/ui/signin_page/login_or_register.dart';
import 'package:AppleYonsei/ui/signin_page/signin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is signed in
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: getUserData(snapshot.data!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                }

                // 카드 등록 여부에 따른 화면 전환
                // if (userSnapshot.hasData) {
                //   // Check the value of cardRegister
                //   bool cardRegister = userSnapshot.data!['cardRegister'] ?? false;
                //   print("===================");
                //   print(cardRegister);
                //   if (!cardRegister) {
                //     return CardPage();
                //   }
                // }

                if (userSnapshot.hasData) {
                  // Check the value of userTypeCustomer
                  bool userTypeCustomer = userSnapshot.data!['userTypeCustomer'] ?? false;

                  if (userTypeCustomer) {
                    // userTypeCustomer is true, show MyHomePage
                    return CustomerMyHomePage(index : 2);
                  } else {
                    // userTypeCustomer is false, show a different page or message
                    return EnterpriseReservationPage(title: "title");
                  }
                } else {
                  // User data not found, handle accordingly
                  return LoginOrRegisterPage();
                }
              },
            );
          } else {
            // User is not signed in
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }
}
