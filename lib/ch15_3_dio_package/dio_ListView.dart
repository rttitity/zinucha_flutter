import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final Dio _dio = Dio();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _isFetchingNextPage = false;
  bool _hasMoreData = true; // 다음 페이지 데이터가 있는지 여부

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // 첫 페이지 데이터 로드
    // 스크롤 리스너 추가: 스크롤이 끝에 도달하면 다음 페이지 데이터 요청
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          !_isFetchingNextPage &&
          _hasMoreData) {
        _currentPage++; // 페이지 번호 증가
        _fetchUsers(); // 다음 페이지 데이터 요청
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 사용자 데이터를 가져오는 비동기 메서드
  Future<void> _fetchUsers() async {
    if (_isFetchingNextPage) return; // 이미 로딩 중이면 중단
    setState(() {
      _isFetchingNextPage = true; // 다음 페이지 로딩 상태 설정
    });

    try {
      // 페이지 번호를 URL에 포함하여 GET 요청을 보냅니다.
      final response = await _dio.get('http://reqres.in/api/users?page=$_currentPage');

      if (response.statusCode == 200) {
        List<dynamic> newUsers = response.data['data'];
        setState(() {
          _users.addAll(newUsers); // 새로운 사용자 데이터를 리스트에 추가
          _isLoading = false;
          _isFetchingNextPage = false;
          _hasMoreData = newUsers.isNotEmpty; // 새 데이터가 없으면 다음 페이지 로드 중지
        });
      } else {
        setState(() {
          _errorMessage = '오류 발생: ${response.statusCode}';
          _isLoading = false;
          _isFetchingNextPage = false;
        });
      }
    } on DioError catch (e) {
      setState(() {
        _errorMessage = '요청 중 오류 발생: $e';
        _isLoading = false;
        _isFetchingNextPage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 목록'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.separated(
        controller: _scrollController, // 스크롤 컨트롤러 설정
        itemCount: _users.length + (_hasMoreData ? 1 : 0), // 로딩 인디케이터를 위한 추가 항목
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          if (index == _users.length) {
            // 로딩 인디케이터 표시
            return Center(child: CircularProgressIndicator());
          }
          final user = _users[index];
          return ListTile(
            title: Text('${user['first_name']} ${user['last_name']}'),
            subtitle: Text(user['email']),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['avatar']),
            ),
          );
        },
      ),
    );
  }
}
