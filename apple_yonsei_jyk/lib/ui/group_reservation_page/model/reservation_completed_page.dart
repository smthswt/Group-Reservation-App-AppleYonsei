import 'package:AppleYonsei/ui/customer_page/customer_home_page.dart';
import 'package:AppleYonsei/ui/reservation_waiting_page/reservation_waiting_page.dart';
import 'package:flutter/material.dart';


class ReservationCompletedPage extends StatelessWidget {
  const ReservationCompletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약 완료'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //여기에 이제 뒤로가기 버튼 눌렀을 때 수행할 동작 추가
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 180,),
            Image.asset(
              'assets/images/reservation_completed.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30,),
            const Text("예약 신청 완료!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30,),
            const Text(
              "단체 예약이 신청되었습니다!\n식당이 최종 예약되면 안내문자가 도착해요!\n핸드폰을 알림을 확인해주세요!",
              style: TextStyle(
                fontSize: 13
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: () {
              CustomerMyHomePage(index: 1,);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerMyHomePage(index: 1),
                ),
              );
            },
                child: Text("예약대기 목록가기!"),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(300, 50)),
                ))
          ],
        ),
      ),
    );
  }
}
