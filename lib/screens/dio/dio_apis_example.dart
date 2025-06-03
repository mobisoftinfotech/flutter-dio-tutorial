import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dio_sample_app/models/post_response_model.dart';
import 'package:flutter_dio_sample_app/screens/dio/api_response_screen.dart';
import 'package:flutter_dio_sample_app/screens/dio/post_form_screen.dart';
import 'package:flutter_dio_sample_app/screens/dio/post_list_screen.dart';


class DioAPIsExample extends StatefulWidget {
  const DioAPIsExample({super.key});

  @override
  DioAPIsExampleState createState() => DioAPIsExampleState();
}

class DioAPIsExampleState extends State<DioAPIsExample> {
  late Dio dio;
  final cache = <String, String>{};

  @override
  void initState() {
    super.initState();
    _createDioClient();
  }

  void _createDioClient() {
    dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
    _addInterceptor();
  }

  void _addInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint(" Request: ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(" Response: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint(" Interceptor error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  void _navigateWithResult(String result) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ApiResponseScreen(result: result)),
    );
  }

  // Request Handlers
  void _getPosts() async {
    try {
      final response = await dio.get('/posts');
      List<Post> posts =
          (response.data as List).map((json) => Post.fromJson(json)).toList();
      if (!mounted) return;
      _navigateToScreen(context, PostListScreen(posts: posts));
    } catch (e) {
      if (!mounted) return;
      _navigateWithResult('GET Error: $e');
    }
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    final route = MaterialPageRoute(builder: (_) => screen);
    Navigator.push(context, route);
  }

  void _updatePost() async {
    try {
      final response = await dio.put(
        '/posts/1',
        data: {'title': 'updated title', 'body': 'updated body', 'userId': 1},
      );
      _navigateWithResult(response.data.toString());
    } catch (e) {
      _navigateWithResult('PUT Error: $e');
    }
  }

  void _performPatch() async {
    try {
      final response = await dio.patch(
        '/posts/1',
        data: {'title': 'patched title'},
      );
      _navigateWithResult(response.data.toString());
    } catch (e) {
      _navigateWithResult('PATCH Error: $e');
    }
  }

  void _deletePost() async {
    try {
      final response = await dio.delete('/posts/1');
      _navigateWithResult(
        'DELETE successful with status code: ${response.statusCode}',
      );
    } catch (e) {
      _navigateWithResult('DELETE Error: $e');
    }
  }

  void _fetchCachedPost() async {
    const key = 'posts/1';
    if (cache.containsKey(key)) {
      _navigateWithResult('From Cache:\n${cache[key]}');
      return;
    }
    try {
      final response = await dio.get('/posts/1');
      cache[key] = response.data.toString();
      _navigateWithResult('From Network:\n${response.data}');
    } catch (e) {
      _navigateWithResult('Cache GET Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dio Methods')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(onPressed: _getPosts, child: Text('GET')),
          ElevatedButton(
            onPressed: () => _navigateToScreen(context, PostFormScreen()),
            child: Text('POST'),
          ),
          ElevatedButton(onPressed: _updatePost, child: Text('PUT')),
          ElevatedButton(onPressed: _performPatch, child: Text('PATCH')),
          ElevatedButton(onPressed: _deletePost, child: Text('DELETE')),
          ElevatedButton(
            onPressed: _fetchCachedPost,
            child: Text('GET with Cache'),
          ),
        ],
      ),
    );
  }
}
