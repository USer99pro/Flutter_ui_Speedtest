import 'dart:convert';

class SpeedTestResult {
  final double downloadRate;
  final double uploadRate;
  final String downloadUnit;
  final String uploadUnit;
  final DateTime timestamp;

  // Constructor for SpeedTestResult
  SpeedTestResult({
    required this.downloadRate,
    required this.uploadRate,
    required this.downloadUnit,
    required this.uploadUnit,
    required this.timestamp,
  });

  // Convert SpeedTestResult instance to a JSON map
  Map<String, dynamic> toJson() => {
        'downloadRate': downloadRate,
        'uploadRate': uploadRate,
        'downloadUnit': downloadUnit,
        'uploadUnit': uploadUnit,
        'timestamp':
            timestamp.toIso8601String(), // Convert DateTime to ISO 8601 string
      };

  // Create a SpeedTestResult instance from a JSON map
  factory SpeedTestResult.fromJson(Map<String, dynamic> json) {
    return SpeedTestResult(
      downloadRate:
          (json['downloadRate'] as num).toDouble(), // Ensure it's a double
      uploadRate:
          (json['uploadRate'] as num).toDouble(), // Ensure it's a double
      downloadUnit: json['downloadUnit'] as String,
      uploadUnit: json['uploadUnit'] as String,
      timestamp: DateTime.parse(
          json['timestamp'] as String), // Parse DateTime from ISO 8601 string
    );
  }

  // Optional: Convert SpeedTestResult to a pretty-printed JSON string
  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  // Optional: Print SpeedTestResult in a readable format
  @override
  String toString() {
    return 'SpeedTestResult(downloadRate: $downloadRate, uploadRate: $uploadRate, '
        'downloadUnit: $downloadUnit, uploadUnit: $uploadUnit, timestamp: $timestamp)';
  }
}
