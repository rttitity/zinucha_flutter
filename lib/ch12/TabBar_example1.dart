import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리 가져오기

void main() {
  runApp(const MyApp()); // MyApp 위젯을 실행하면 앱의 시작
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  HomeScreenState createState() => HomeScreenState(); // 상태 객체 생성
}

class HomeScreenState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController controller; // TabController 선언

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this); // 3개의 탭을 가진 TabController 초기화
  }

  @override
  void dispose() {
    controller.dispose(); // 사용이 끝난 TabController 메모리 해제
    super.dispose(); // 부모 클래스의 dispose 호출
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tab Test 2024001761 차진우'), // 앱의 제목 설정
          bottom: TabBar(
            controller: controller, // TabController 연결
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.looks_one), text: 'One'), // 첫 번째 탭
              Tab(icon: Icon(Icons.looks_two), text: 'Two'), // 두 번째 탭
              Tab(icon: Icon(Icons.looks_3), text: 'Three'), // 세 번째 탭
            ],
          ),
        ),
        body: TabBarView(
          controller: controller, // TabController 연결
          children: const <Widget>[
            Center(
              child: Text(
                'One Screen', // 첫 번째 화면의 텍스트
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
              ),
            ),
            Center(
              child: Text(
                'Two Screen', // 두 번째 화면의 텍스트
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
              ),
            ),
            Center(
              child: Text(
                'Three Screen', // 세 번째 화면의 텍스트
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
