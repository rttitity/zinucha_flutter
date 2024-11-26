import 'package:flutter_lab2024001761/youtube_project/component/custom_youtube_player.dart'; // CustomYoutubePlayer 위젯
import 'package:flutter_lab2024001761/youtube_project/model/video_model.dart'; // VideoModel 클래스
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리

// HomeScreen 클래스: 앱의 홈 화면을 구성하는 StatelessWidget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // 생성자: 키를 받아 초기화

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기본 구조인 Scaffold 위젯 반환
      backgroundColor: Colors.black, // 배경색을 검정색으로 설정
      body: CustomYoutubePlayer(
        // CustomYoutubePlayer 위젯 사용
        videoModel: VideoModel(
          // VideoModel 인스턴스 생성
          id: 'LGtNgpzI6tc', // 동영상 ID 설정
          title: '다른 어떤 기기에서 1시간 안에 끝내기', // 동영상 제목 설정
        ),
      ), // CustomYoutubePlayer
    ); // Scaffold
  }
}
