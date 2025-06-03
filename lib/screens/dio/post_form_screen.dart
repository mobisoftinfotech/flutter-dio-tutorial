import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dio_sample_app/models/post_response_model.dart';


class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key});

  @override
  PostFormScreenState createState() => PostFormScreenState();
}

class PostFormScreenState extends State<PostFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final Dio dio = Dio(
    BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'),
  );

  void _makePost() async {
    try {
      final response = await dio.post(
        '/posts',
        data: {
          'title': _titleController.text,
          'body': _bodyController.text,
          'userId': 1,
        },
      );

      final post = Post.fromJson(response.data);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(title: Text("POST Result")),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Post ID: ${post.id}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('User ID: ${post.userId}'),
                      Text('Title: ${post.title}'),
                      Text('Body: ${post.body}'),
                    ],
                  ),
                ),
              ),
        ),
      );
      _titleController.clear();
      _bodyController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("POST failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
                hintText: 'Enter the body',
              ),
              maxLines: 2,
              minLines: 1,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _makePost, child: Text("Add Post")),
          ],
        ),
      ),
    );
  }
}
