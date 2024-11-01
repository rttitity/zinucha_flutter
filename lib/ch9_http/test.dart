import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HttpApp();
  }
}

class _HttpApp extends State<HttpApp> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Example 2024001761_차진우'),
      ),
      body: Container(
        child: Center(
          child: Text('$result'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var url = 'http://www.google.com';  // CORS 오류 해결해야함
          var response = await http.get(Uri.parse(url));
          setState(() {
            result = response.body;
          });
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
}
