import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'iOS 스타일 계산기';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: _title,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: CalculatorApp(),
    );
  }
}

// 상태 관리 위젯
class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}


// UI의 동작 관리
class _CalculatorAppState extends State<CalculatorApp> {
  String input = ''; // 입력 필드에 보여줄 값, 이곳에서 식을 입력을 하고 '=' 버튼을 누르면 계산이 된다.
  String result = ''; // input 필드 식의 결과값이 저장된다.
  bool hasResult = false; // 연산 결과가 표시되었는지 여부

  void buttonPressed(String value) {
    setState(() {

//------ 이전 연산 결과가 있고 새로운 입력이 시작되면, 결과를 입력 필드로 옮김------
      if (hasResult && RegExp(r'[0-9]').hasMatch(value)) {
        input = value;
        result = '';
        hasResult = false;
        return;
      }
//------ C 버튼을 누르면 입/출력 필드 초기화 ------
      if (value == 'C') {
        input = '';
        result = '';
        hasResult = false;
      }
//------ BackSpace 버튼을 누를시 입력필드의 문자열 삭제 ------
      else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      }
//------ '=' 버튼 누를시 수식을 계산 ------
      else if (value == '=') {
        result = _evaluateExpression(input);
        hasResult = true;
      }
//---- 숫자나 연산자 버튼을 눌렀을 때 수식을 입력 필드에 추가 -----
      else {
        input += value;
      }
    });
  }

  // 입력 필드의 문자열 수식을 읽고 연산을 처리하는 함수
  String _evaluateExpression(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth / 4;

    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('iOS 스타일 계산기'),
        backgroundColor: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        input,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w400, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        result,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w400, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          // 버튼 컨테이너
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: _buildButtonGrid(buttonSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 버튼들을 GridView로 정렬
  Widget _buildButtonGrid(double buttonSize) {
    return GridView.count(
      crossAxisCount: 4, // 한 행에 4개의 버튼
      childAspectRatio: 1, // 버튼의 가로 세로 비율을 동일하게 설정
      mainAxisSpacing: 10, // 버튼들 사이의 세로 간격
      crossAxisSpacing: 10, // 버튼들 사이의 가로 간격
      padding: const EdgeInsets.all(10),
      children: <Widget>[
        _buildButton('C', Colors.grey, Colors.black, buttonSize),
        _buildButton('±', Colors.grey, Colors.black, buttonSize),
        _buildButton('%', Colors.grey, Colors.black, buttonSize),
        _buildButton('/', Colors.orange, Colors.white, buttonSize),
        _buildButton('7', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('8', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('9', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('*', Colors.orange, Colors.white, buttonSize),
        _buildButton('4', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('5', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('6', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('-', Colors.orange, Colors.white, buttonSize),
        _buildButton('1', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('2', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('3', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('+', Colors.orange, Colors.white, buttonSize),
        _buildButton('.', Colors.grey[900]!, Colors.white, buttonSize, widthMultiplier: 2),
        _buildButton('0', Colors.grey[900]!, Colors.white, buttonSize),
        _buildButton('⌫', Colors.orange, Colors.white, buttonSize),
        _buildButton('=', Colors.orange, Colors.white, buttonSize),
      ],
    );
  }

  // 버튼 위젯 생성 함수
  Widget _buildButton(String label, Color bgColor, Color textColor, double buttonSize, {int widthMultiplier = 1}) {
    return Container(
      width: buttonSize * widthMultiplier, // 버튼 크기를 화면에 맞게 설정
      height: buttonSize,
      child: CupertinoButton(
        color: bgColor,
        padding: const EdgeInsets.all(10),
        onPressed: () => buttonPressed(label),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
