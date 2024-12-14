// Firebase와 Flutter의 주요 패키지를 가져옵니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg) {      // 토스트 메시지를 화면에 표시하는 함수
  Fluttertoast.showToast(
      msg: msg, // 출력할 메시지
      toastLength: Toast.LENGTH_SHORT, // 짧은 시간 동안 표시
      gravity: ToastGravity.CENTER, // 화면 중앙에 표시
      timeInSecForIosWeb: 1, // iOS 및 웹에서 표시 시간
      backgroundColor: Colors.red, // 배경색: 빨간색
      textColor: Colors.white, // 글자색: 흰색
      fontSize: 16.0 // 글자 크기
  );
}

// 앱의 진입점(Main 함수)
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 플랫폼별 Firebase 설정 적용
  );
  runApp(MyApp()); // 앱 실행
}

// 전체 앱을 정의하는 MyApp 클래스
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // 앱 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 기본 색상 테마
      ),
      home: AuthWidget(), // 첫 화면으로 AuthWidget 지정
    );
  }
}

// 인증 화면을 담당하는 StatefulWidget
class AuthWidget extends StatefulWidget {
  @override
  AuthWidgetState createState() => AuthWidgetState(); // 상태 생성
}

// 인증 로직 및 UI 상태를 관리하는 State 클래스
class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>(); // 폼 유효성 검사용 키

  late String email; // 사용자 이메일
  late String password; // 사용자 비밀번호
  bool isInput = true; // 입력 화면 여부(true: 입력, false: 결과)
  bool isSignIn = true; // 로그인 여부(true: 로그인, false: 회원가입)

  // 로그인 처리 함수
  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value); // 성공 결과 출력
        if (value.user!.emailVerified) { // 이메일 인증 여부 확인
          setState(() {
            isInput = false; // 결과 화면으로 전환
          });
        } else {
          showToast('emailVerified error'); // 이메일 인증 실패 메시지
        }
        return value; // 결과 반환
      });
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 에러 처리
      if (e.code == 'user-not-found') {
        showToast('user-not-found'); // 사용자 없음 메시지
      } else if (e.code == 'wrong-password') {
        showToast('wrong-password'); // 비밀번호 오류 메시지
      } else {
        print(e.code); // 기타 오류 코드 출력
      }
    }
  }

  // 로그아웃 처리 함수
  signOut() async {
    await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
    setState(() {
      isInput = true; // 입력 화면으로 전환
    });
  }
  // 회원가입 처리 함수
  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.email != null) { // 계정 생성 성공 여부 확인
          FirebaseAuth.instance.currentUser?.sendEmailVerification(); // 이메일 인증 요청
          setState(() {
            isInput = false; // 결과 화면으로 전환
          });
        }
        return value; // 결과 반환
      });
    } on FirebaseAuthException catch (e) {
      // Firebase 회원가입 에러 처리
      if (e.code == 'weak-password') {
        showToast('weak-password'); // 비밀번호 보안 약함 메시지
      } else if (e.code == 'email-already-in-use') {
        showToast('email-already-in-use'); // 이메일 중복 메시지
      } else {
        showToast('other error'); // 기타 오류 메시지
        print(e.code); // 오류 코드 출력
      }
    } catch (e) {
      print(e.toString()); // 기타 예외 출력
    }
  }

  // 입력 화면 UI 생성
  List<Widget> getInputWidget() {
    return [
      // 로그인 또는 회원가입 제목
      Text(
        isSignIn ? "SignIn" : "SignUp", // 현재 상태에 따라 제목 변경
        style: const TextStyle(
          color: Colors.indigo, // 텍스트 색상
          fontWeight: FontWeight.bold, // 굵은 글씨
          fontSize: 20, // 글씨 크기
        ),
        textAlign: TextAlign.center, // 중앙 정렬
      ),
      // 이메일 및 비밀번호 입력 폼
      Form(
        key: _formKey, // 유효성 검사를 위한 키
        child: Column(
          children: [
            // 이메일 입력 필드
            TextFormField(
              decoration: InputDecoration(labelText: 'email'), // 라벨
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter email'; // 빈 입력 시 메시지
                }
                return null; // 유효성 통과
              },
              onSaved: (String? value) {
                email = value ?? ""; // 이메일 저장
              },
            ),
            // 비밀번호 입력 필드
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'password', // 라벨
              ),
              obscureText: true, // 비밀번호 입력 시 숨김
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter password'; // 빈 입력 시 메시지
                }
                return null; // 유효성 통과
              },
              onSaved: (String? value) {
                password = value ?? ""; // 비밀번호 저장
              },
            ),
          ],
        ),
      ),
      // 로그인/회원가입 버튼
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) { // 유효성 검사 통과 시
            _formKey.currentState?.save(); // 폼 데이터 저장
            print('email: $email, password : $password'); // 디버깅용 출력
            if (isSignIn) {
              signIn(); // 로그인 호출
            } else {
              signUp(); // 회원가입 호출
            }
          }
        },
        child: Text(isSignIn ? "SignIn" : "SignUp"), // 버튼 텍스트
      ),

      // 상태 전환 링크 (로그인 <-> 회원가입)
      RichText(
        textAlign: TextAlign.right, // 오른쪽 정렬
        text: TextSpan(
          text: 'Go ', // 설명 텍스트
          // style: Theme.of(context).textTheme.bodyText1, // 기본 텍스트 스타일
          style: Theme.of(context).textTheme.bodyLarge, // 변경된 코드
          children: <TextSpan>[
            TextSpan(
                text: isSignIn ? "SignUp" : "SignIn", // 현재 상태에 따라 텍스트 변경
                style: const TextStyle(
                  color: Colors.blue, // 색상
                  fontWeight: FontWeight.bold, // 굵은 글씨
                  decoration: TextDecoration.underline, // 밑줄
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isSignIn = !isSignIn; // 상태 전환
                    });
                  }),
          ],
        ),
      ),
    ];
  }

  // 결과 화면 UI 생성
  List<Widget> getResultWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!; // 현재 사용자 이메일
    return [
      Text(
        isSignIn
            ? "$resultEmail 로 로그인 하셨습니다.!" // 로그인 결과 메시지
            : "$resultEmail 로 회원가입 하셨습니다.! 이메일 인증을 거쳐야 로그인이 가능합니다.", // 회원가입 결과 메시지
        style: const TextStyle(
          color: Colors.black54, // 텍스트 색상
          fontWeight: FontWeight.bold, // 굵은 글씨
        ),
      ),
      // 로그아웃/다시 로그인 버튼
      ElevatedButton(
        onPressed: () {
          if (isSignIn) {
            signOut(); // 로그아웃 호출
          } else {
            setState(() {
              isInput = true; // 입력 화면으로 전환
              isSignIn = true; // 로그인 상태로 전환
            });
          }
        },
        child: Text(isSignIn ? "SignOut" : "SignIn"), // 버튼 텍스트
      ),
    ];
  }

  // 화면 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("인증테스트 인덕대"), // 앱 제목
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 너비 최대 확장
          children: isInput ? getInputWidget() : getResultWidget()), // 상태에 따라 화면 선택
    );
  }
}