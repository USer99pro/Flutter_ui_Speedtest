import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'speed_test_result.dart'; // Ensure this is your model class

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<SpeedTestResult> _history = []; // List to hold SpeedTestResult objects

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? history = prefs.getStringList(
          'speedTestResults'); // Updated key to match SpeedTestUi
      if (history != null) {
        setState(() {
          _history = history
              .map((item) => SpeedTestResult.fromJson(jsonDecode(item)))
              .toList();
        });
      }
    } catch (e) {
      // Handle error or show an alert
      print('Failed to load history: $e');
    }
  }

  Future<void> _clearHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs
          .remove('speedTestResults'); // Updated key to match SpeedTestUi
      setState(() {
        _history.clear();
      });
    } catch (e) {
      // Handle error or show an alert
      print('Failed to clear history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Test History'),
        backgroundColor: const Color.fromARGB(255, 73, 110, 222),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearHistory,
            color: Colors.white,
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No history available.',
                style: TextStyle(
                  color: Colors.white, // Updated for better readability
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final result = _history[index];
                return Card(
                  color: const Color.fromARGB(255, 54, 98, 143),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Download: ${result.downloadRate.toStringAsFixed(2)} ${result.downloadUnit}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Upload: ${result.uploadRate.toStringAsFixed(2)} ${result.uploadUnit}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      _formatTimestamp(result.timestamp),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
