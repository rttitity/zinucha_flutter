import 'dart:io'; // 파일 작업을 위해 사용
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore와 연결
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage와 연결
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위해 사용
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 사용
import '../firebase_options.dart'; // Firebase 옵션 파일
import 'package:fluttertoast/fluttertoast.dart'; // 사용자 알림 (Toast 메시지)

/// 사용자에게 Toast 메시지를 보여주는 함수
void showToast(String msg, {Color backgroundColor = Colors.red}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

/// Content 모델 클래스: Firestore에 저장할 데이터 구조
class Content {
  final String content; // 사용자가 입력한 텍스트
  final String downloadUrl; // 업로드된 이미지의 URL
  final String date; // 데이터 저장 날짜

  Content({required this.content, required this.downloadUrl, required this.date});

  // Firestore에서 데이터를 가져올 때 사용하는 팩토리 메서드
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      content: json['content'] ?? '',
      downloadUrl: json['downloadurl'] ?? '',
      date: json['date'] ?? '',
    );
  }

  // Firestore에 데이터를 저장할 때 사용하는 메서드
  Map<String, dynamic> toJson() => {
    'content': content,
    'downloadurl': downloadUrl,
    'date': date,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

/// 애플리케이션 메인 클래스
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/list', // 첫 화면은 '/list'로 설정
      routes: {
        '/list': (context) => const ListScreen(), // 리스트 화면
        '/input': (context) => const InputScreen(), // 입력 화면
      },
    );
  }
}

/// Firestore의 데이터를 보여주는 리스트 화면
class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Firestore 컬렉션 참조 (withConverter를 사용해 Content 모델과 연결)
    final contentsRef = FirebaseFirestore.instance.collection('contents').withConverter<Content>(
      fromFirestore: (snapshots, _) => Content.fromJson(snapshots.data()!),
      toFirestore: (content, _) => content.toJson(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Uploaded Content List')), // 상단 앱바
      body: StreamBuilder<QuerySnapshot<Content>>(
        stream: contentsRef.snapshots(), // Firestore에서 실시간 데이터 가져오기
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 에러 발생 시 표시
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator()); // 데이터 로딩 중
          }

          final data = snapshot.requireData; // Firestore 데이터 가져오기
          return ListView.builder(
            itemCount: data.docs.length, // 문서 개수만큼 리스트 생성
            itemBuilder: (context, index) {
              final content = data.docs[index].data(); // 각 문서 데이터
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(content.downloadUrl), // 업로드된 이미지 표시
                    Text(content.date, style: const TextStyle(color: Colors.black54)), // 날짜 표시
                    Text(content.content, style: const TextStyle(fontSize: 20)), // 입력된 텍스트 표시
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/input'), // 입력 화면으로 이동
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 사용자가 데이터를 입력하고 업로드하는 화면
class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  final TextEditingController controller = TextEditingController(); // 텍스트 입력 컨트롤러
  XFile? _image; // 선택된 이미지 파일
  String? downloadUrl; // 업로드된 이미지 URL
  bool isUploading = false; // 업로드 진행 상태

  @override
  void dispose() {
    controller.dispose(); // 메모리 해제
    super.dispose();
  }

  /// 갤러리에서 이미지 선택
  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image; // 이미지 상태 업데이트
    });
  }

  /// Firebase Storage에 파일 업로드
  Future<void> uploadFile() async {
    if (_image == null) {
      showToast('No file selected');
      return;
    }

    setState(() {
      isUploading = true; // 업로드 시작
    });

    try {
      // 중복 방지를 위해 파일명에 타임스탬프 추가
      final ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}_${_image!.name}');
      await ref.putFile(File(_image!.path)); // 파일 업로드
      downloadUrl = await ref.getDownloadURL(); // 다운로드 URL 가져오기
      debugPrint('Download URL: $downloadUrl');
      showToast('File uploaded successfully', backgroundColor: Colors.green);
    } catch (e) {
      showToast('Upload failed: $e');
      debugPrint('Upload error: $e');
    } finally {
      setState(() {
        isUploading = false; // 업로드 완료
      });
    }
  }

  /// Firestore에 데이터 저장
  Future<void> saveContent() async {
    final contentText = controller.text;

    if (contentText.isEmpty || _image == null || downloadUrl == null) {
      showToast('Invalid data for saving');
      return;
    }

    final content = Content(
      content: contentText,
      downloadUrl: downloadUrl!,
      date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
    );

    try {
      await FirebaseFirestore.instance.collection('contents').add(content.toJson());
      showToast('Content saved successfully', backgroundColor: Colors.green);
      Navigator.pop(context); // 이전 화면으로 돌아가기
    } catch (e) {
      showToast('Save failed: $e');
      debugPrint('Save error: $e');
    }
  }

  /// 파일 업로드 후 데이터 저장
  Future<void> handleSave() async {
    await uploadFile(); // 파일 업로드
    if (downloadUrl != null) {
      await saveContent(); // 업로드 성공 후 Firestore에 저장
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Content'),
        actions: [
          IconButton(icon: const Icon(Icons.photo_album), onPressed: pickImage), // 이미지 선택
          IconButton(icon: const Icon(Icons.save), onPressed: handleSave), // 업로드 및 저장 실행
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_image != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Image.file(File(_image!.path)), // 선택된 이미지 표시
              )
            else
              const Center(child: Text("No image selected", style: TextStyle(color: Colors.grey))),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Data',
                prefixIcon: Icon(Icons.input),
                border: OutlineInputBorder(),
                hintText: 'Enter data',
                helperText: 'Please enter the content data.',
              ),
            ),
            if (isUploading)
              const Center(child: CircularProgressIndicator()), // 업로드 상태 표시
          ],
        ),
      ),
    );
  }
}
