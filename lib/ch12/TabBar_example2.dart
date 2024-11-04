import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리 가져오기

void main() {
  runApp(MyApp()); // MyApp 위젯을 실행하면 앱의 시작
}

class MyApp extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState(); // 상태 객체 생성
}

class HomeScreenState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController controller; // TabController 선언

  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 호출
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
          title: const Text('Tab Test 20241023 안덕임'), // 앱의 제목 설정
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
          children: <Widget>[
            tabContent('One Screen', '이곳은 첫 번째 화면입니다.', Colors.blue), // 첫 번째 탭 내용
            tabContent('Two Screen', '이곳은 두 번째 화면입니다.', Colors.green), // 두 번째 탭 내용
            tabContent('Three Screen', '이곳은 세 번째 화면입니다.', Colors.red), // 세 번째 탭 내용
          ],
        ),
      ),
    );
  }
  Widget tabContent(String title, String description, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
        children: [
          Text(
            title, // 각 탭의 제목
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
          ),
          SizedBox(height: 20), // 제목과 설명 사이의 간격
          Text(
            description, // 각 탭의 설명
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center, // 텍스트 중앙 정렬
          ),
          SizedBox(height: 30), // 설명과 버튼 사이의 간격
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title 버튼 클릭됨!')), // 버튼 클릭 시 스낵바 표시
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: color), // 버튼 색상 설정
            child: Text('클릭해주세요'), // 버튼 텍스트
          ),
        ],
      ),
    );
  }
}


