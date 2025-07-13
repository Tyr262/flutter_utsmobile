import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

// Fungsi untuk fetch data post dari API
Future<List<Post>> fetchPost() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    final List jsonData = json.decode(response.body);
    return jsonData.map((e) => Post.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}
