import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsmobile/controllers/controller_post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Posts App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      home: ListPostPage(),
    );
  }
}

class ListPostPage extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Post')),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: postController.posts.length,
          itemBuilder: (context, index) {
            final post = postController.posts[index];
            return Card(
              child: ListTile(
                title: Text(post.title),
                onTap: () {
                  Get.to(
                    () => DetailPostPage(
                      postId: post.id,
                      title: post.title,
                      body: post.body,
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}

class DetailPostPage extends StatelessWidget {
  final int postId;
  final String title;
  final String body;

  const DetailPostPage({
    super.key,
    required this.postId,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(body),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Get.to(() => CommentPage(postId: postId, title: title));
                },
                child: const Text('View Comment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentPage extends StatelessWidget {
  final int postId;
  final String title;

  CommentPage({super.key, required this.postId, required this.title});

  final PostController postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    postController.fetchComments(postId);

    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (postController.isCommentLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: postController.comments.length,
                itemBuilder: (context, index) {
                  final comment = postController.comments[index];
                  return ListTile(
                    title: Text(comment['name'] ?? ''),
                    subtitle: Text(comment['body'] ?? ''),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
