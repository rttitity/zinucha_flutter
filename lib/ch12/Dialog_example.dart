import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Flutter에서 날짜 형식을 포맷하기 위해 사용

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dialog 예제 2024001761 차진우'), // 앱바의 제목 설정
        ),
        body: TestScreen(), // 메인 화면에 TestScreen 위젯 설정
      ),
    );
  }
}


class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  TestState createState() => TestState();
}

class TestState extends State<TestScreen> {
  DateTime dateValue = DateTime.now(); // 선택한 날짜를 저장하는 변수
  TimeOfDay? timeValue; // 선택한 시간을 저장하는 변수

  _dialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 외부를 터치해도 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dialog Title"), // 다이얼로그의 제목
          content: Column(
            mainAxisSize: MainAxisSize.min, // 다이얼로그의 최소 사이즈 설정
            children: [
              const TextField(
                decoration: InputDecoration(border: OutlineInputBorder()), // 텍스트 입력 필드의 테두리 설정
              ),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}), // 체크박스 추가
                  const Text("수신동의"), // 체크박스 옆의 텍스트
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text("OK"), // 확인 버튼 텍스트
            ),
          ],
        );
      },
    );
  }



  _bottomSheet() {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.yellow, // 바텀 시트의 배경색 설정
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min, // 최소한의 높이만 차지
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('ADD'), // 항목 제목
              onTap: () {
                Navigator.of(context).pop(); // 바텀 시트 닫기
              },
            ),
            ListTile(
              leading: Icon(Icons.remove),
              title: Text('REMOVE'), // 항목 제목
              onTap: () {
                Navigator.of(context).pop(); // 바텀 시트 닫기
              },
            ),
          ],
        );
      },
    );
  }


  _modalBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.yellow,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text('ADD'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.remove),
                title: Text('REMOVE'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateValue,
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        dateValue = picked; // 선택한 날짜 업데이트
      });
    }
  }

  Future timePicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // 초기 시간을 현재 시간으로 설정
    );
    if (selectedTime != null) {
      setState(() {
        timeValue = selectedTime; // 선택한 시간 업데이트
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 위젯 중앙 정렬
        children: [
          ElevatedButton(onPressed: _dialog, child: Text("dialog")), // 다이얼로그 열기 버튼
          ElevatedButton(onPressed: _bottomSheet, child: Text("bottomSheet")), // 바텀 시트 열기 버튼
          ElevatedButton(onPressed: _modalBottomSheet, child: Text("modalBottomSheet")), // 모달 바텀 시트 열기 버튼
          ElevatedButton(onPressed: datePicker, child: Text("datePicker")), // 날짜 선택기 버튼
          ElevatedButton(onPressed: timePicker, child: Text("timePicker")), // 시간 선택기 버튼
          Text('date : ${DateFormat('yyyy-MM-dd').format(dateValue)}'), // 선택한 날짜 표시
          if (timeValue != null)
            Text('time : ${timeValue!.hour}:${timeValue!.minute}'), // 선택한 시간 표시
        ],
      ),
    );
  }
}
