import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 Material 디자인 라이브러리
import 'package:flutter_lab2024001761/youtube_project/model/video_model.dart'; // VideoModel 클래스 임포트
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // 유튜브 플레이어 패키지 임포트

// 유튜브 동영상 플레이어 위젯 클래스
class CustomYoutubePlayer extends StatefulWidget {
  // 동영상 데이터를 저장할 변수
  final VideoModel videoModel;

  const CustomYoutubePlayer({
    required this.videoModel, // 필수 매개변수
    super.key, // 기본 키 매개변수
  });

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState(); // 상태 클래스 생성
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  YoutubePlayerController? controller; // 유튜브 플레이어 컨트롤러 변수

  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 호출

    // 유튜브 플레이어 컨트롤러 초기화
    controller = YoutubePlayerController(
      initialVideoId: widget.videoModel.id, // 처음 실행할 동영상 ID 설정
      flags: const YoutubePlayerFlags(
        autoPlay: false, // 자동 재생 사용하지 않기
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // build 함수는 세 번째 이미지로 연결됩니다.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯을 부모 너비에 맞춤
      children: [
        // 유튜브 플레이어 위젯
        YoutubePlayer(
          controller: controller!, // 설정한 컨트롤러 사용
          showVideoProgressIndicator: true, // 동영상 진행 표시기 표시
        ),
        const SizedBox(height: 16.0), // 위젯 간 간격 설정
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 패딩 설정
          child: Text(
            widget.videoModel.title, // 동영상 제목 표시
            style: const TextStyle(
              color: Colors.white, // 텍스트 색상 흰색
              fontSize: 16.0, // 텍스트 크기 설정
              fontWeight: FontWeight.w700, // 텍스트 굵기 설정
            ),
          ),
        ),
      ],
    );
  }
}