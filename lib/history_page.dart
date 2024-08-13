import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'speed_test_result.dart';
import 'speed_test_ui.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<SpeedTestResult> _history = []; // Use SpeedTestResult as the type

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    setState(() {
      _history = history
          .map((item) => SpeedTestResult.fromJson(jsonDecode(item)))
          .toList();
    });
  }

  Future<void> _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Test History'),
        backgroundColor: Color.fromARGB(255, 73, 110, 222),
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
                  color: const Color.fromARGB(255, 0, 0, 0),
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
                  child: ListTile(
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
