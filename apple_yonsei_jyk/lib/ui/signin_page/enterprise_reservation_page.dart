import 'package:AppleYonsei/ui/enterprise_page/enterprise_home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnterpriseReservationPage extends StatefulWidget {
  const EnterpriseReservationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<EnterpriseReservationPage> createState() => _EnterpriseReservationPageState();
}


class _EnterpriseReservationPageState extends State<EnterpriseReservationPage> {

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _keyword = '';
  String _intro = '';
  String _menu = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,


                            )),

                        hintText: '가게 이름을 입력하세요',
                        labelText: '가게 이름 입력',
                        errorStyle: TextStyle(),

                      ),
                      maxLength: 30,
                      onSaved: (value) {
                        setState(() {
                          _name = value as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 입력 항목입니다*';
                        }
                        return null;
                      },

                    ),
                  ],
                )),


            Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),

                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,


                            )),
                        hintText: '연관 검색어를 입력해주세요',
                        labelText: '연관 검색어 입력',
                      ),
                      maxLength: 100,
                      onSaved: (value) {
                        setState(() {
                          _keyword = value as String;
                        });
                      },
                    ),
                  ],
                )),


            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,


                            )),

                        hintText: '가게를 소개해주세요',
                        labelText: '가게 소개 입력',
                        errorStyle: TextStyle(),

                      ),

                      maxLines: 3,
                      maxLength: 200,

                      onSaved: (value) {
                        setState(() {
                          _intro = value as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 입력 항목입니다*';
                        }
                        return null;
                      },

                    ),
                  ],
                )),


            Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),

                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,


                            )),
                        hintText: '메뉴를 입력해주세요',
                        labelText: '메뉴 입력',
                      ),
                      maxLength: 200,
                      maxLines: 3,
                      onSaved: (value) {
                        setState(() {
                          _menu = value as String;
                        });
                      },

                    ),


                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20)),


                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 40),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          try {
                            final user = FirebaseAuth.instance.currentUser;

                            if (user == null) {
                              // 사장님 로그인되어 있지 않으면 로그인
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: 'jjw@gmail.com',
                                password: 'test123',
                              );

                              final user = FirebaseAuth.instance.currentUser;
                            }

                            if (user != null) {
                              await FirebaseFirestore.instance.collection('enterprise_info').add({
                                'name': _name,
                                'keyword': _keyword,
                                'intro': _intro,
                                'menu': _menu,
                                // 'user': user.email,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('가게 정보가 성공적으로 등록되었습니다.')),
                              );
                            }
                          } catch (e) {
                            print('Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('가게 정보 등록에 실패했습니다.')),
                            );
                          }
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EnterpriseMyHomePage(title: "title")));
                      },
                      child: const Text('등록하기'),
                    ),

                  ],
                )),
          ],
        ),
      ),
    );
  }
}