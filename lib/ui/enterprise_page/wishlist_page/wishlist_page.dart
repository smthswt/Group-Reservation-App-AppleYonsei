import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getData() async {
  var result = await FirebaseFirestore.instance.collection('test_dave').get();
  return result.docs
      .where((doc) => doc['resv_confirm'] == true)
      .map((doc) => doc.data())
      .toList();
}

class WishlistPage extends StatefulWidget {
  final bool isShrink;

  const WishlistPage({required this.isShrink, Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List<Map<String, dynamic>>> getDataFuture;

  @override
  void initState() {
    super.initState();
    getDataFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ReservText(),
              ReservationSum(dataFuture: getDataFuture),  // <-- Add this line
              ReservListText(),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('에러: ${snapshot.error}');
                  } else {
                    List<Widget> reservationWidgets = [];
                    for (var data in snapshot.data!) {
                      String dateData = data['date'] ?? '';
                      String numPeople = data['num_people'].toString() ?? '';
                      String name = data['name'].toString() ?? '';
                      String phoneNum = data['phone_num'].toString() ?? '';
                      String resvTime = data['resv_time'].toString() ?? '';

                      reservationWidgets.add(
                        Reservationlist(
                          dateData: dateData,
                          numPeople: numPeople,
                          name: name,
                          phoneNum: phoneNum,
                          resvTime: resvTime,
                        ),
                      );
                    }
                    return Column(children: reservationWidgets);
                  }
                },
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class Reservationlist extends StatelessWidget {
  final String dateData;
  final String numPeople;
  final String name;
  final String phoneNum;
  final String resvTime;

  const Reservationlist({required this.dateData, required this.numPeople, required this.name, required this.phoneNum, required this.resvTime, Key? key}) : super(key: key);

  String getDayOfWeek(String date) {
    try {
    final DateTime dateTime = DateTime.parse(date);
    switch (dateTime.weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  } catch (e) {
      print('Invalid date format: $date');
      return '';
    }
  }

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
                      "$dateData $resvTime",
                      style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: double.nan),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(1, 0, 3, 0),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
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
                  height: 4,
                ),
                Text("$numPeople 명"),
                Text("$name, $phoneNum"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReservationSum extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> dataFuture;

  const ReservationSum({required this.dataFuture, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('에러: ${snapshot.error}');
        } else {
          int currentDayReservations = snapshot.data?.length ?? 0;

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
                    child: Text(currentDate),
                  ),
                ),
                Container(width: 1, height: 30, color: Colors.grey,),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("예약 확정: $currentDayReservations 팀"),
                  ),
                )
              ],
            ),
          );
        }
      },
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
