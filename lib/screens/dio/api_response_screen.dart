import 'package:flutter/material.dart';

class ApiResponseScreen extends StatelessWidget {
  final String result;

  const ApiResponseScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Response')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            result,
            style: TextStyle(fontSize: 14, fontFamily: 'Courier'),
          ),
        ),
      ),
    );
  }
}
