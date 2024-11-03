import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController controller = PageController(
    initialPage: 1,
    viewportFraction: 0.8,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('PageView Example 2024001761 차진우')),
        body: PageView(
          controller: controller,
          children: [
            Container(margin: EdgeInsets.all(20), color: Colors.red),
            Container(margin: EdgeInsets.all(20), color: Colors.yellow),
            Container(margin: EdgeInsets.all(20), color: Colors.green),
          ],
        ),
      ),
    );
  }
}
