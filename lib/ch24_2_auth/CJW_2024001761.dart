// Firebase와 Flutter 관련 패키지 임포트
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화 기능
import 'package:flutter/cupertino.dart'; // Cupertino 스타일 위젯을 위한 패키지
import '../firebase_options.dart'; // Firebase 설정 파일 (CJW_2024001761.dart)

// 앱의 진입점 main() 함수
void main() async {
  // Flutter 프레임워크 초기화 작업을 보장하는 코드
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 플랫폼에 맞는 Firebase 설정을 사용
  );

  // Firebase 초기화가 완료된 후 앱 실행
  runApp(MyApp());
}

// Flutter 앱의 구조를 정의하는 MyApp 클래스
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cupertino 스타일의 앱 설정
    return const CupertinoApp(
      title: 'Firebase Flutter App 2024001761 차진우', // 앱의 제목
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Firebase 예제 인덕대 2024001761 차진우'), // 네비게이션 바의 제목
        ), // CupertinoNavigationBar
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            children: [
              Image(
                image: AssetImage('images/induk.png'), // 이미지 에셋 경로
                width: 150, // 이미지 너비
                height: 150, // 이미지 높이
              ),
              SizedBox(height: 10),
              Text('Firebase Initialized!'), // 화면 중앙에 텍스트 표시
            ],
          ),
        ), // Center
      ), // CupertinoPageScaffold
    ); // CupertinoApp
  }
}
