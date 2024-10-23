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
      theme: CupertinoThemeData(
        brightness: Brightness.dark, // 전체적으로 다크 테마 적용
      ),
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String input = ''; // 입력 필드에 보여줄 값 (연산자 포함)
  String result = ''; // 결과값
  double? firstOperand; // 첫 번째 피연산자
  String? operator; // 연산자
  bool isNextOperand = false; // 다음 피연산자 입력 여부 확인용
  bool hasResult = false; // 연산 결과가 표시되었는지 여부

  void buttonPressed(String value) {
    setState(() {
      // 이전 연산 결과가 있고 새로운 입력이 시작되면, 결과를 입력 필드로 옮김
      if (hasResult && RegExp(r'[0-9]').hasMatch(value)) {
        input = value;
        result = '';
        hasResult = false;
        return;
      }

      // 숫자를 입력할 때
      if (RegExp(r'[0-9]').hasMatch(value)) {
        if (isNextOperand) {
          input += value; // 연산자가 입력된 후 두 번째 숫자
          isNextOperand = false; // 두 번째 피연산자 입력 완료
        } else {
          input += value; // 연속 숫자 입력을 위해 이어붙임
        }
      } else if (value == 'C') {
        input = '';
        result = '';
        firstOperand = null;
        operator = null;
        isNextOperand = false;
        hasResult = false;
      } else if (value == '⌫') {
        // Backspace 기능: 입력된 마지막 글자를 삭제
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        if (firstOperand != null && operator != null) {
          double secondOperand = double.tryParse(input.split(operator!).last) ?? 0;
          result = _calculate(firstOperand!, secondOperand, operator!);
          hasResult = true; // 연산 결과가 출력된 상태
        }
      } else {
        // 연산자가 입력된 경우
        if (firstOperand == null) {
          firstOperand = double.tryParse(input); // 첫 번째 피연산자를 저장
        } else if (!isNextOperand) {
          // 이미 피연산자가 있을 때는 현재 입력된 값을 두 번째 피연산자로 계산
          double secondOperand = double.tryParse(input.split(operator!).last) ?? 0;
          result = _calculate(firstOperand!, secondOperand, operator!);
          firstOperand = double.tryParse(result); // 결과를 첫 번째 피연산자로 저장
        }
        operator = value; // 연산자 설정
        input += ' $value '; // 연산자를 입력 필드에 표시
        isNextOperand = true; // 두 번째 피연산자를 기다림
        hasResult = false; // 새로운 연산 시작 시 결과를 초기화
      }
    });
  }

  // 사칙연산을 처리하는 함수
  String _calculate(double num1, double num2, String operator) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth / 4; // 버튼 크기는 화면 너비의 1/4로 설정

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
      crossAxisCount: 4,
      childAspectRatio: 1,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
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
        _buildButton('0', Colors.grey[900]!, Colors.white, buttonSize, widthMultiplier: 2),
        _buildButton('.', Colors.grey[900]!, Colors.white, buttonSize),
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
