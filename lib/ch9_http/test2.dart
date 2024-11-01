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
        title: Text('HTTP Example 2024001761_차진우'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Text(result),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var url = 'https://jsonplaceholder.typicode.com/posts/1';
          var response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            setState(() {
              result = response.body;
            });
          } else {
            setState(() {
              result = 'Failed to load data';
            });
          }
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
}
