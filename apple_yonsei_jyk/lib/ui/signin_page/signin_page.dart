import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/signin_page/model/my_button.dart';
import 'package:AppleYonsei/ui/signin_page/model/my_textfield.dart';
import 'package:AppleYonsei/ui/signin_page/model/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//convert to stateful : opt + .
class SigninPage extends StatefulWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Function()? onTap;

  SigninPage({super.key, required this.onTap});

  @override
  State<SigninPage> createState() => _SigninPageState();
}
// class UserDB {
//   final String email;
//   final String password;
//   late bool userTypeCustomer;
//   late bool userTypeEnterprise;
//
//   UserDB({required this.email, required this.password, required this.userTypeCustomer, required this.userTypeEnterprise});
//
//   factory UserDB.fromJson(Map<String, dynamic> json) {
//     return UserDB(
//       email: json["email"],
//       password: json["password"],
//       userTypeCustomer : json["userTypeCustomer"],
//       userTypeEnterprise : json["userTypeEnterprise"],
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       "email": email,
//       "password": password,
//       "userTypeCustomer": userTypeCustomer,
//       "userTypeEnterprise" : userTypeEnterprise,
//     };
//   }
// }
class _SigninPageState extends State<SigninPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //try sign in & catch error
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // print("HELLO WORLD---------------------");
      // print(emailController.text);
      // Fetch user information from Firestore based on email
      var querySnapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: emailController.text).get();

      // Check if there is a document that matches the query
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve user data from the first document in the result
        var userData = querySnapshot.docs.first.data();

        // Check if userTypeCustomer field exists and is a boolean
        if (userData.containsKey("userTypeCustomer") && userData["userTypeCustomer"] is bool) {
          // Retrieve and print userTypeCustomer value
          bool userTypeCustomer = userData["userTypeCustomer"];
          print("User Type Customer: $userTypeCustomer");
        } else {
          print("User Type Customer field not found or not a boolean.");
        }
      } else {
        print("User not found in Firestore.");
      }
    // }
    // catch (e) {
    //   // Handle sign-in errors
    //   print("Error during sign-in: $e");
    // }

      var result_new = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: emailController.text).get();
      print(result_new);
      print(emailController.text);

      var result = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      print(result.data());
      print("User sign in succesfully!");

      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch(e) {
      //pop the loading circle
      Navigator.pop(context);
      //Wrong Email
      if (e.code == 'invalid-email') {
        //show error
        wrongEmailMessage();
      }
      else if (e.code == 'invalid-login-credentials') {
        wrongPasswordMessage();
      }
    }
    }
    //wrong email message popup
    void wrongEmailMessage(){
      showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            title: Text('이메일을 잘못 입력하였습니다!'),
          );
        },
      );
    }
    //wrong email message popup
    void wrongPasswordMessage(){
      showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            title: Text('비밀번호를 잘못 입력하였습니다!'),
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Center(
                  child: Text(
                    'Hello //One Click 단체 예약! \n Apple Yonsei에 오신 것을 환영합니다 :)',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: '이메일',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: '비밀번호',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '비밀번호를 잊으셨나요?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUserIn,
                  text: "로그인",
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '소셜 로그인',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    SquareTile(imagePath: 'images/google.png'),

                    SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'images/apple.png')
                  ],
                ),

                const SizedBox(height: 50),

                // not a member? register now
                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
