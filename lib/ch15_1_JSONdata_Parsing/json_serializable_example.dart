import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_serializable_example.g.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

@JsonSerializable()
class Location {
  String latitude;
  String longitude;

  Location(this.latitude, this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Todo {
  @JsonKey(name: "id")
  int todoId;
  String title;
  bool completed;
  Location location;

  Todo(this.todoId, this.title, this.completed, this.location);
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

}

class MyAppState extends State<MyApp> {
  String jsonStr = '{"id": 2024001761, "title": "HELLO", "completed": false, "location": {"latitude": "37.5", "longitude": "127.1"}}';
  Todo? todo; // Todo 객체를 저장할 변수
  String result = ''; // 결과 메시지를 저장할 변수

  // JSON 문자열을 파싱하여 Todo 객체로 변환하는 메서드
  void onPressDecode() {
    Map<String, dynamic> map = jsonDecode(jsonStr); // JSON 문자열을 Map으로 변환
    todo = Todo.fromJson(map); // Map을 Todo 객체로 변환
    setState(() {
      // 상태 업데이트
      result = "decode : ${todo?.toJson()}";
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