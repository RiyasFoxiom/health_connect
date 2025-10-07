import '../utils/salt_generator.dart';

class HealthMetadata {
  final String salt;
  final DateTime timestamp;
  final String dataType;
  final String hash;

  HealthMetadata({
    required this.salt,
    required this.timestamp,
    required this.dataType,
    required this.hash,
  });

  Map<String, dynamic> toJson() {
    return {
      'salt': salt,
      'timestamp': timestamp.toIso8601String(),
      'dataType': dataType,
      'hash': hash,
    };
  }

  factory HealthMetadata.fromJson(Map<String, dynamic> json) {
    return HealthMetadata(
      salt: json['salt'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      dataType: json['dataType'] as String,
      hash: json['hash'] as String,
    );
  }

  /// Verifies if this metadata's salt matches the expected salt
  Future<bool> verifySalt() async {
    return await SaltGenerator.verifySalt(salt);
  }
}