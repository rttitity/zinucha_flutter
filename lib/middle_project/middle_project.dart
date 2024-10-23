import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'iOS 스타일 계산기';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: _title,
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String input = ''; // 입력 값
  String result = ''; // 결과 값

  void buttonPressed(String value) {
    setState(() {
      // '=' 버튼을 눌렀을 때 계산을 처리하고, 나머지는 입력에 추가
      if (value == '=') {
        try {
          // String expression을 실제 계산 결과로 변환하는 부분
          result = _calculate(input);
        } catch (e) {
          result = 'Error';
        }
      } else if (value == 'C') {
        input = '';
        result = '';
      } else {
        input += value;
      }
    });
  }

  // 간단한 계산을 처리하는 함수
  String _calculate(String input) {
    // 기본 사칙연산을 처리하기 위해 간단히 파싱 및 처리
    // eval을 사용하지 않고 간단한 계산만 지원
    double num1 = 0;
    double num2 = 0;
    String operator = '';

    List<String> tokens = input.split(RegExp(r'(\D)')); // 숫자와 연산자를 분리

    if (tokens.length == 2) {
      num1 = double.tryParse(tokens[0]) ?? 0;
      num2 = double.tryParse(tokens[1]) ?? 0;
      operator = input.replaceAll(RegExp(r'\d'), ''); // 연산자 추출
    }

    switch (operator) {
      case '+':
        return (num1 + num2).toString();
      case '-':
        return (num1 - num2).toString();
      case '*':
        return (num1 * num2).toString();
      case '/':
        if (num2 == 0) return '0으로 나눌 수 없습니다.';
        return (num1 / num2).toString();
      default:
        return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('iOS 스타일 계산기'),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                input,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['C', '0', '=', '+']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((String value) {
        return CupertinoButton(
          padding: const EdgeInsets.all(20),
          onPressed: () => buttonPressed(value),
          child: Text(
            value,
            style: const TextStyle(fontSize: 30),
          ),
        );
      }).toList(),
    );
  }
}
