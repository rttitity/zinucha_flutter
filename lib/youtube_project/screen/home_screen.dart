import 'package:flutter_lab2024001761/youtube_project/component/custom_youtube_player.dart'; // CustomYoutubePlayer 위젯 임포트
import 'package:flutter_lab2024001761/youtube_project/model/video_model.dart'; // VideoModel 클래스 임포트
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리 임포트
import 'package:flutter_lab2024001761/youtube_project/repository/youtube_repository.dart'; // YouTube 비디오를 가져오는 리포지토리 임포트

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // 생성자: 키를 받아 초기화

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // HomeScreenState를 생성
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기본 구조인 Scaffold 위젯 반환
      backgroundColor: Colors.blue, // 배경색을 설정
      appBar: AppBar(
        centerTitle: true, // 제목을 중앙 정렬
        title: const Text(
          '인덕 Tube', // AppBar에 표시될 제목
        ),
        backgroundColor: Colors.black, // AppBar 배경색을 검정색으로 설정
      ),
      body: FutureBuilder<List<VideoModel>>(
        // 비디오 목록을 비동기적으로 가져오기 위한 FutureBuilder
        future: YoutubeRepository.getVideos(), // 비디오를 가져오는 Future 호출
        builder: (context, snapshot) {
          // Future의 상태에 따라 UI를 빌드
          if (snapshot.hasError) {
            // 오류가 발생한 경우
            return Center(
              child: Text(
                snapshot.error.toString(), // 오류 메시지를 중앙에 표시
              ),
            );
          }
          if (!snapshot.hasData) {
            // 데이터가 아직 로드되지 않은 경우
            return const Center(
              child: CircularProgressIndicator(), // 로딩 인디케이터를 중앙에 표시
            );
          }

          // 데이터가 준비된 경우 ListView로 비디오 목록 표시
          return RefreshIndicator(
            // 사용자가 아래로 당길 때 새로 고침 기능 추가
            onRefresh: () async {
              setState(() {
                // 상태를 업데이트하여 UI를 다시 빌드
              });
            },
            child: ListView(
              physics: const BouncingScrollPhysics(), // 스크롤 시 반동 효과 설정
              children: snapshot.data!
                  .map(
                    (e) => CustomYoutubePlayer(videoModel: e),
              ) // 각 비디오 모델을 CustomYoutubePlayer로 변환
                  .toList(), // 리스트로 변환하여 반환
            ),
          );
        },
      ),
    );
  }
}
