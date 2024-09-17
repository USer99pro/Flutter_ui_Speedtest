import 'package:flutter/material.dart';
import 'speed_test_result.dart'; // Ensure this file exists and is correctly named
import 'speed_test_ui.dart'; // Ensure this file exists and is correctly named
import 'iplookup.dart'; // Ensure this file exists and is correctly named

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Disable the debug banner in production
      title: 'Speed Test and IP Lookup', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Theme color
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adjust visual density for different platforms
      ),
      home: const SpeedTestUi(), // Entry point of the app
      routes: {
        // Define named routes if needed
        '/speedTest': (context) => const SpeedTestUi(),
        '/ipLookup': (context) =>
            const IPLookupPage(), // Ensure IPLookupPage is defined
      },
    );
  }
}
