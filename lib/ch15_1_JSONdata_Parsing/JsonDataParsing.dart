import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 라이브러리
import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 머티리얼 디자인을 위한 라이브러리

void main() {
  runApp(const MyApp()); // MyApp 클래스를 실행하여 Flutter 애플리케이션 시작
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // StatefulWidget 생성자

  @override
  State<MyApp> createState() => _MyAppState(); // State 객체 생성
}

class Todo {
  int id; // Todo 항목의 ID
  String title; // Todo 항목의 제목
  bool completed; // Todo 항목의 완료 여부

  // 생성자
  Todo(this.id, this.title, this.completed);

  // JSON으로부터 Todo 객체 생성
  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        completed = json['completed'];

  // Todo 객체를 JSON 형식으로 변환
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };
}

class _MyAppState extends State<MyApp> {
  // JSON 형식의 문자열 (Todo 데이터)
  String jsonStr = '{"id": 2024001761, "title": "인덕대", "completed": false}';
  Todo? todo; // Todo 객체를 저장할 변수
  String result = ''; // 결과 메시지를 저장할 변수

  // JSON 문자열을 파싱하여 Todo 객체로 변환하는 메서드
  void onPressDecode() {
    Map<String, dynamic> map = jsonDecode(jsonStr); // JSON 문자열을 Map으로 변환
    todo = Todo.fromJson(map); // Map을 Todo 객체로 변환
    setState(() {
      // 상태 업데이트
      result =
      'Decoded: id: ${todo?.id}, title: ${todo?.title}, completed: ${todo?.completed}';
    });
  }

  // Todo 객체를 JSON 형식으로 인코딩하는 메서드
  void onPressEncode() {
    setState(() {
      // 상태 업데이트
      if (todo != null) {
        result = 'Encoded: ${jsonEncode(todo)}'; // Todo 객체를 JSON 문자열로 변환
      } else {
        result = 'No Todo to encode'; // Todo 객체가 없을 경우의 메시지
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test 인덕대 2024001761 차진우'), // 앱 바 제목
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            children: [
              Text(
                result, // 결과 메시지 표시
                style: const TextStyle(fontSize: 18), // 글자 크기를 24로 설정
              ),
              const SizedBox(height: 20), // 버튼 사이의 여백 추가
              ElevatedButton(
                onPressed: onPressDecode, // 버튼 클릭 시 onPressDecode 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 배경 색상을 청색으로 설정
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // 버튼의 패딩 설정
                  textStyle: const TextStyle(fontSize: 20), // 버튼 텍스트 크기 설정
                ),
                child: const Text('Decode'), // 버튼 텍스트
              ),
              const SizedBox(height: 20), // 버튼 사이의 여백 추가
              ElevatedButton(
                onPressed: onPressEncode, // 버튼 클릭 시 onPressEncode 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan, // 버튼 배경 색상을 청색으로 설정
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // 버튼의 패딩 설정
                  textStyle: const TextStyle(fontSize: 20), // 버튼 텍스트 크기 설정
                ),
                child: const Text('Encode'), // 버튼 텍스트
              ),
            ],
          ),
        ),
      ),
    );
  }
}
