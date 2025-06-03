import 'package:flutter/material.dart';
import 'package:flutter_dio_sample_app/models/post_response_model.dart';


class PostListScreen extends StatelessWidget {
  final List<Post> posts;

  const PostListScreen({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Posts')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.body),
            leading: CircleAvatar(child: Text('${post.id}')),
          );
        },
      ),
    );
  }
}
