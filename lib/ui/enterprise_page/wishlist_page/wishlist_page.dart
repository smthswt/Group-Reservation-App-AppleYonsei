import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/enterprise_page/login_page/login_overlay_widget.dart';
import 'package:AppleYonsei/ui/enterprise_page/common/animated_scale_screen_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<String> getData() async {
  var result = await FirebaseFirestore.instance
      .collection('test_dave')
      .doc('BjzUyw5qtolsytuiw6ZB')
      .get();
  print(result.data());
  print('Firebase 데이터 가져오기 성공');

  return result.data()?['date'] ?? '';
}

class WishlistPage extends StatefulWidget {
  final bool isShrink;

  const WishlistPage({required this.isShrink, Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<String> dateData;

  @override
  void initState() {
    super.initState();
    dateData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ReservText(),
              ReservationSum(),
              ReservListText(),
              FutureBuilder<String>(
                future: dateData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('에러: ${snapshot.error}');
                  } else {
                    return Reservationlist(dateData: snapshot.data ?? '');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Reservationlist extends StatelessWidget {
  final String dateData;

  const Reservationlist({required this.dateData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 100,
      width: 300,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.calendar_month, size: 50,),
          Container(
            height: 100,
            width: 220,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateData,
                      style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: double.nan),
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "예약 확정",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 8,
                ),
                Text("8 명 (예약 인원 수)"),
                Text("김현호, 010-1234 (예약자 정보)"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReservationSum extends StatelessWidget {
  const ReservationSum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text("11월 16일 (필터)"),
            ),
          ),
          Container(width: 1, height: 30, color: Colors.grey,),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text("예약 확정: 3 팀"),
            ),
          )
        ],
      ),
    );
  }
}

class ReservText extends StatelessWidget {
  const ReservText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 300,
      margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
      child: Text("예약 내역"),
    );
  }
}

class ReservListText extends StatelessWidget {
  const ReservListText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 300,
      margin: EdgeInsets.fromLTRB(4, 10, 0, 0),
      child: Text("예약 목록"),
    );
  }
}

void main() {
  runApp(WishlistPage(isShrink: false));
}
