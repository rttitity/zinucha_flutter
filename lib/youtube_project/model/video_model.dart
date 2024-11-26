/// VideoModel 클래스: 동영상 정보를 저장하는 모델
class VideoModel {
  /// 동영상 ID: 고유한 식별자
  final String id; // 동영상 ID

  /// 동영상 제목: 동영상의 제목
  final String title; // 동영상 제목

  /// 생성자: VideoModel 인스턴스를 생성할 때 사용
  VideoModel({
    required this.id, // ID는 필수 매개변수
    required this.title, // 제목은 필수 매개변수
  });
}
