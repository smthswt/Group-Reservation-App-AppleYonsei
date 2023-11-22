import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetReservations extends StatelessWidget {
  final String documentID;
  final double bRad;
  final int bColor;

  GetReservations({
    required this.documentID,
    required this.bRad,
    required this.bColor,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference reservations =
        FirebaseFirestore.instance.collection('reservation_waiting');

    return FutureBuilder<DocumentSnapshot>(
      future: reservations.doc(documentID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
              height: 60,
              // width: screenWidth,
              margin: const EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: Color(bColor),
                borderRadius: BorderRadius.circular(bRad),
              ),
              child: Column(
                children: [
                  Text('${data['user'] ?? 'loading...'}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("${data['person'] ?? 'loading...'}명"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("${data['time'] ?? 'loading...'} 시"),
                      )
                    ],
                  ),
                ],
              ));

          // Text('First Name: ${data['first name']}');
        }
        return Text('Loading...');
      },
    );
  }
}
