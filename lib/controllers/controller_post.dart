import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:utsmobile/models/model_post.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  var comments = [].obs;
  var isCommentLoading = false.obs;

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  void fetchPosts() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        posts.value = jsonData.map((e) => Post.fromJson(e)).toList();
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchComments(int postId) async {
    try {
      isCommentLoading(true);
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));
      if (response.statusCode == 200) {
        comments.value = json.decode(response.body);
      }
    } finally {
      isCommentLoading(false);
    }
  }
}