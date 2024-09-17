import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class IPLookupPage extends StatefulWidget {
  const IPLookupPage({super.key});

  @override
  _IPLookupPageState createState() => _IPLookupPageState();
}

class _IPLookupPageState extends State<IPLookupPage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _ipInfo;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _lookupIP() async {
    setState(() {
      _isLoading = true;
      _ipInfo = null; // Clear previous info
      _errorMessage = null; // Clear previous error message
    });

    final ip = _controller.text.trim();
    if (ip.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter an IP address.';
      });
      return;
    }

    final url = Uri.parse('https://ipapi.co/$ip/json/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _ipInfo = json.decode(response.body) as Map<String, dynamic>;
        });
      } else if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        final waitTime =
            retryAfter != null ? int.tryParse(retryAfter) ?? 60 : 60;
        setState(() {
          _errorMessage =
              'Too many requests. Please wait $waitTime seconds and try again.';
        });
        await Future.delayed(Duration(seconds: waitTime));
        _lookupIP(); // Retry after waiting
      } else {
        setState(() {
          _ipInfo = null;
          _errorMessage =
              'Failed to retrieve IP information. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _ipInfo = null;
        _errorMessage = 'An error occurred: $e';
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
                : _errorMessage != null
                    ? Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      )
                    : _ipInfo != null
                        ? Expanded(
                            child: ListView(
                              children: [
                                if (_ipInfo!.containsKey('ip')) ...[
                                  _buildInfoTile('IP Address', _ipInfo!['ip']),
                                ],
                                if (_ipInfo!.containsKey('city')) ...[
                                  _buildInfoTile('City', _ipInfo!['city']),
                                ],
                                if (_ipInfo!.containsKey('region')) ...[
                                  _buildInfoTile('Region', _ipInfo!['region']),
                                ],
                                if (_ipInfo!.containsKey('country')) ...[
                                  _buildInfoTile(
                                      'Country', _ipInfo!['country']),
                                ],
                                if (_ipInfo!.containsKey('country_name')) ...[
                                  _buildInfoTile(
                                      'Country Name', _ipInfo!['country_name']),
                                ],
                                if (_ipInfo!
                                    .containsKey('country_capital')) ...[
                                  _buildInfoTile('Country Capital',
                                      _ipInfo!['country_capital']),
                                ],
                                if (_ipInfo!.containsKey('country_tld')) ...[
                                  _buildInfoTile(
                                      'Country TLD', _ipInfo!['country_tld']),
                                ],
                                if (_ipInfo!.containsKey('country_area')) ...[
                                  _buildInfoTile(
                                      'Country Area', _ipInfo!['country_area']),
                                ],
                                if (_ipInfo!.containsKey('in_eu')) ...[
                                  _buildInfoTile('In EU', _ipInfo!['in_eu']),
                                ],
                                if (_ipInfo!.containsKey('org')) ...[
                                  _buildInfoTile(
                                      'Organization', _ipInfo!['org']),
                                ],
                               
                              ],
                            ),
                          )
                        : const Text('No information available'),
          ],
        ),
      ),
    );
  }

  ListTile _buildInfoTile(String title, dynamic value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value.toString()),
    );
  }
}
