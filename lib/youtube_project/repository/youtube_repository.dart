import 'package:flutter_lab2024001761/youtube_project/const/api.dart'; // API 상수를 포함한 파일 임포트
import 'package:dio/dio.dart'; // Dio HTTP 클라이언트 패키지 임포트
import 'package:flutter_lab2024001761/youtube_project/model/video_model.dart'; // VideoModel 클래스 임포트

// YouTubeRepository 클래스: YouTube 비디오 데이터를 가져오는 리포지토리
class YoutubeRepository {
  // 비디오 목록을 비동기적으로 가져오는 정적 메서드
  static Future<List<VideoModel>> getVideos() async {
    // Dio를 사용해 YouTube API에 GET 요청을 보냅니다.
    final resp = await Dio().get(
      YOUTUBE_API_BASE_URL, // API의 기본 URL
      queryParameters: {
        'channelId': CF_CHANNEL_ID, // 채널 ID 파라미터
        'channelID': K_CHANNEL_ID, // 채널 ID 파라미터
        'maxResults': 50, // 최대 결과 수
        'key': API_KEY, // API 키
        'part': 'snippet', // 응답의 일부로 포함할 데이터 파트
        'order': 'date', // 결과 정렬 순서 (날짜 기준)
      },
    );

    // 응답 데이터에서 비디오 ID와 제목이 있는 아이템만 필터링
    final listWithData = resp.data['items'].where(
          (item) =>
      item['id']?['videoId'] != null && // videoId가 존재하는지 확인
          item['snippet']?['title'] != null, // 제목이 존재하는지 확인
    );

    // 필터링된 아이템을 VideoModel 객체로 변환하고 리스트로 반환
    return listWithData
        .map<VideoModel>(
          (item) => VideoModel(
        id: item['id']['videoId'], // VideoModel의 id에 videoId 할당
        title: item['snippet']['title'], // VideoModel의 title에 제목 할당
      ),
    )
        .toList(); // 최종적으로 리스트로 변환하여 반환
  }
}
