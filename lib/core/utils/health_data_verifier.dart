import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/health_metadata.dart';
import 'salt_generator.dart';

class HealthDataVerifier {
  /// Creates a metadata entry for health data
  static Future<HealthMetadata> createMetadata({
    required String dataType,
    required dynamic data,
  }) async {
    final salt = await SaltGenerator.generateSalt();
    final timestamp = DateTime.now();
    
    // Create a hash of the data using the salt
    final dataString = jsonEncode(data);
    final input = '$salt:$dataString';
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes).toString().toLowerCase();
    
    return HealthMetadata(
      salt: salt,
      timestamp: timestamp,
      dataType: dataType,
      hash: hash,
    );
  }

  /// Verifies the integrity of health data using its metadata
  static Future<bool> verifyData({
    required HealthMetadata metadata,
    required dynamic data,
  }) async {
    // First verify the salt
    if (!await metadata.verifySalt()) {
      return false;
    }

    // Then verify the data hash
    final dataString = jsonEncode(data);
    final input = '${metadata.salt}:$dataString';
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes).toString().toLowerCase();

    return hash == metadata.hash;
  }

  /// Creates a deterministic hash for a set of health data
  static String hashHealthData(String salt, dynamic data) {
    final dataString = jsonEncode(data);
    final input = '$salt:$dataString';
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString().toLowerCase();
  }
}