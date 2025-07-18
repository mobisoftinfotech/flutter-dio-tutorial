import 'package:flutter/material.dart';
import 'package:flutter_dio_sample_app/screens/dio/dio_apis_example.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      themeMode: ThemeMode.light,
      home: DioAPIsExample(),
    );
  }
}
