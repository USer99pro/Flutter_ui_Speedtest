import 'dart:convert';

class SpeedTestResult {
  final double downloadRate;
  final double uploadRate;
  final String downloadUnit;
  final String uploadUnit;
  final DateTime timestamp;

  SpeedTestResult({
    required this.downloadRate,
    required this.uploadRate,
    required this.downloadUnit,
    required this.uploadUnit,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'downloadRate': downloadRate,
        'uploadRate': uploadRate,
        'downloadUnit': downloadUnit,
        'uploadUnit': uploadUnit,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SpeedTestResult.fromJson(Map<String, dynamic> json) {
    return SpeedTestResult(
      downloadRate: json['downloadRate'],
      uploadRate: json['uploadRate'],
      downloadUnit: json['downloadUnit'],
      uploadUnit: json['uploadUnit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
