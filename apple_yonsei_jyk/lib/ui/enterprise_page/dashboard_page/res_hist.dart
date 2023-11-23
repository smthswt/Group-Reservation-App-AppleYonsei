import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetHistory extends StatelessWidget {
  final String documentID;
  final double bRad;
  final int bColor;

  GetHistory({
    required this.documentID,
    required this.bRad,
    required this.bColor,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference reservations =
        FirebaseFirestore.instance.collection('reservation_confirm');

    return FutureBuilder<DocumentSnapshot>(
      future: reservations.doc(documentID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            margin: const EdgeInsets.all(2.0),
            // width: 800,
            decoration: BoxDecoration(
              color: Color(bColor),
              borderRadius: BorderRadius.circular(bRad),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.calendar_month),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${data['time'] ?? 'loading...'} 시"),
                    Text("${data['person'] ?? 'loading...'}명"),
                    Text('${data['user'] ?? 'loading...'}'),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: Text("예약확정"))
              ],
            ),
          );

          // Text('First Name: ${data['first name']}');
        }
        return Text('Loading...');
      },
    );
  }
}
