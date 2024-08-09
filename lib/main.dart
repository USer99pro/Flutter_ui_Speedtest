// main.dart

import 'package:flutter/material.dart';
import 'speed_test_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove this line in production
      title: 'Internet Speed Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeedTestUi(),
    );
  }
}
