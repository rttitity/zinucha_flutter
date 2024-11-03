import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  String name;
  String phone;
  String email;
  User(this.name, this.phone, this.email);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  List<User> users = [
    User('김**', '010101', 'abc@induk.ac.kr'),
    User('이**', '010102', 'abc@induk.ac.kr'),
    User('박**', '010103', 'abc@induk.ac.kr'),
    User('최**', '010104', 'abc@induk.ac.kr'),
    User('장**', '010105', 'abc@induk.ac.kr'),
    User('임꺽정1', '010101', 'abc@induk.ac.kr'), User('장보고2', '010102', 'abc@induk.ac.kr'),
    User('임꺽정3', '010103', 'abc@induk.ac.kr'), User('장보고4', '010104', 'abc@induk.ac.kr'),
    User('임꺽정5', '010105', 'abc@induk.ac.kr'), User('장보고6', '010106', 'abc@induk.ac.kr'),
    User('임꺽정7', '010107', 'abc@induk.ac.kr'), User('장보고8', '010108', 'abc@induk.ac.kr'),
    User('임꺽정9', '010109', 'abc@induk.ac.kr'), User('장보고10', '010110', 'abc@induk.ac.kr'),
    User('임꺽정11', '010111', 'abc@induk.ac.kr'), User('장보고12', '010112', 'abc@induk.ac.kr'),
    User('임꺽정13', '010113', 'abc@induk.ac.kr'), User('장보고14', '010114', 'abc@induk.ac.kr'),
    User('임꺽정15', '010115', 'abc@induk.ac.kr'), User('장보고16', '010116', 'abc@induk.ac.kr'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Test 2024001761 차진우')),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 줄에 표시할 항목 개수
            crossAxisSpacing: 10, // 항목 사이의 가로 간격
            mainAxisSpacing: 10, // 항목 사이의 세로 간격
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('images/induk.png'),
                  ),
                  SizedBox(height: 10),
                  Text(users[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(users[index].phone),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      print(users[index].name);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
