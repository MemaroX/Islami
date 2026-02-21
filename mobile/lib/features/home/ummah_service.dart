import 'package:dio/dio.dart';

class Post {
  final int id;
  final String author;
  final String content;
  final int likes;

  Post({required this.id, required this.author, required this.content, required this.likes});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      likes: json['likes'],
    );
  }
}

class UmmahService {
  final _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('/ummah/posts');
      return (response.data as List).map((p) => Post.fromJson(p)).toList();
    } catch (e) {
      print('Error fetching Ummah posts: $e');
      return [];
    }
  }
}
