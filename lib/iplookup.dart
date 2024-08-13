import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'speed_test_ui.dart';

class IPLookupPage extends StatefulWidget {
  @override
  _IPLookupPageState createState() => _IPLookupPageState();
}

class _IPLookupPageState extends State<IPLookupPage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _ipInfo;
  bool _isLoading = false;

  Future<void> _lookupIP() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://ipapi.co/${_controller.text}/json/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _ipInfo = json.decode(response.body) as Map<String, dynamic>;
      });
    } else {
      setState(() {
        _ipInfo = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to retrieve IP information.')),
        );
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Lookup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter IP Address',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _lookupIP,
                ),
              ),
              onSubmitted: (_) =>
                  _lookupIP(), // Trigger search when Enter key is pressed
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _lookupIP,
              child: const Text('Lookup IP'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _ipInfo != null
                    ? Expanded(
                        child: ListView(
                          children: _ipInfo!.entries.map((entry) {
                            return ListTile(
                              title: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(entry.value.toString()),
                            );
                          }).toList(),
                        ),
                      )
                    : const Text('No information available'),
          ],
        ),
      ),
    );
  }
}
