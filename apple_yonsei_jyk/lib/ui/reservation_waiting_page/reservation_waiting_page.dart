import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/login_page/login_overlay_widget.dart';
import 'package:AppleYonsei/ui/common/animated_scale_screen_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReservationWaitingPage extends StatefulWidget {
  const ReservationWaitingPage({Key? key}) : super(key: key);

  @override
  _ReservationWaitingPageState createState() => _ReservationWaitingPageState();
}

class _ReservationWaitingPageState extends State<ReservationWaitingPage> {
  int _selectedIndex = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // List to hold data from Firebase
  List<Map<String, dynamic>> reservationData = [];
  List<Map<String, dynamic>> reservationWaitingData = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 확정'),
      ),
      body: Column(
          children: [
            // Add a simple ListTile
            ListTile(
              contentPadding: EdgeInsets.all(10),
              tileColor: Colors.amber,
              title: Text(
                "예약대기 내역",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Use ListView.builder to dynamically create ListTiles
            Expanded(
              child: ListView.builder(
                itemCount: reservationWaitingData.length,
                itemBuilder: (context, index) {
                  var dataWaiting = reservationWaitingData[index];
                  return ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(dataWaiting['prefer'] + " 관련 " + dataWaiting["location"] + "지역 식당을 찾고 있어요!"),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("장소 : " + dataWaiting['location']),
                            Text("시간 : " + dataWaiting['time']),
                            Text("인원 : " + dataWaiting['person'] + " 명"),
                            Text("선호 메뉴 : " + dataWaiting['prefer']),
                            Text("비선호 메뉴 : " + dataWaiting['unprefer']),
                            // Add more subtitles as needed
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              //예약 취소하기
                            },
                            child: const Text("예약 취소",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              minimumSize: MaterialStateProperty.all(Size(50,50)),
                            ))
                      ],
                    ),
                    onTap: () {
                      // Add your onTap logic here
                    },
                  );
                },
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.all(10),
              tileColor: Colors.amber,
              title: Text(
                "예약확정 내역",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Use ListView.builder to dynamically create ListTiles
            Expanded(
              child: ListView.builder(
                itemCount: reservationData.length,
                itemBuilder: (context, index) {
                  var data = reservationData[index];
                  return ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(data['식당']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['예약여부']),
                        Text(data['위치']),
                        Text(data['전화번호']),
                        // Add more subtitles as needed
                      ],
                    ),
                    onTap: () {
                      // Add your onTap logic here
                    },
                  );
                },
              ),
            ),
          ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    // Fetch data from Firebase and update the reservationData list
    _fetchDataFromFirebase();

  }



  void _fetchDataFromFirebase() async {

    //email 불러오기
    var result = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // List<Map<String, dynamic>> result_uid = result.map((doc) => doc.data() as Map<String, dynamic>).toList();
    print("HELLO WORLD---------------------");
    String userEmail = result['email'];
    print(userEmail);
    //예약확정 내역 데이터 불러오기
    var snapshot = await FirebaseFirestore.instance.collection('reservation_customer_confirm').get();
    var documents = snapshot.docs;



    //예약대기 내역 데이터 불러오기
    var snapshot_waiting_query = await FirebaseFirestore.instance.collection("reservation_waiting").where("user", isEqualTo: userEmail).get();
    var documents_waiting_query = snapshot_waiting_query.docs;


    setState(() {

      //예약확정 내역 데이터 불러오기
      reservationData = documents.map((doc) => doc.data() as Map<String, dynamic>).toList();

      //예약대기 내역 데이터 불러오기
      reservationWaitingData = documents_waiting_query.map((doc) => doc.data() as Map<String, dynamic>).toList();


    });



  }


}

