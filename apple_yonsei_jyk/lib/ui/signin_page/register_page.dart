import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/signin_page/model/my_button.dart';
import 'package:AppleYonsei/ui/signin_page/model/my_textfield.dart';
import 'package:AppleYonsei/ui/signin_page/model/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//convert to stateful : opt + .
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class CheckboxController {
  final ValueNotifier<bool> valueNotifier;

  CheckboxController(bool initialValue) : valueNotifier = ValueNotifier<bool>(initialValue);

  bool get value => valueNotifier.value;

  set value(bool newValue) {
    valueNotifier.value = newValue;
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final firestore = FirebaseFirestore.instance;
  late CheckboxController checkboxController1;
  late CheckboxController checkboxController2;
  bool cardRegister = false;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // try creating the user
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    // try {
    //
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailController.text,
    //     password: passwordController.text,
    //   );
    //   print("confirmed");
    // } catch (e) {
    //   print('Error: $e');
    // }

    try {
      //check if password is confirmed
      if(passwordController.text != confirmPasswordController.text){
        //pop the loading circle
        Navigator.pop(context);
        showErrorMessage();
        return;
      } else {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email' : emailController.text,
          'password' : passwordController.text,
          'userTypeCustomer' : checkboxController1.value,
          'userTypeEnterprise' : checkboxController2.value,
          'cardRegister' : cardRegister,
        });
        print("User registered succesfully!");

      }
      // pop the loading circle
      Navigator.pop(context);

    }

    on FirebaseAuthException catch(e) {
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
      else if (e.code == 'weak-password') {
        weakPasswordMessage();
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
  void showErrorMessage(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text("비밀번호가 일치하지 않습니다!"),
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
  //wrong email message popup
  void weakPasswordMessage(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text('비밀번호를 6자 이상 작성하세요!'),
        );
      },
    );
  }
  @override
  void initState(){
    super.initState();
      checkboxController1 = CheckboxController(true);
      checkboxController2 = CheckboxController(false);
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
                  Icons.app_registration,
                  size: 50,
                ),

                const SizedBox(height: 10),
                // welcome back, you've been missed!
                Center(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 30,
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

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: '비밀번호를 다시 입력해주세요',
                  obscureText: true,
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('일반 고객'),
                        Checkbox(
                          value: checkboxController1.value,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxController1.value = value!;
                              if (checkboxController1.value) {
                                // If checkbox1 is checked, uncheck checkbox2
                                checkboxController2.value = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('사장님/기업'),
                        Checkbox(
                          value: checkboxController2.value,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxController2.value = value!;
                              if (checkboxController2.value) {
                                // If checkbox2 is checked, uncheck checkbox1
                                checkboxController1.value = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // sign in button
                MyButton(
                  onTap: signUserUp,
                  text: "회원가입",
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
                        '이미 계정이 있으신가요?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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

