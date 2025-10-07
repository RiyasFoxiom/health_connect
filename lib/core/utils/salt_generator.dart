import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class SaltGenerator {
  static String? _cachedSalt;

  /// Generates a deterministic SALT using package name and first git commit hash
  /// SALT = SHA256("${packageName}:${firstGitCommitHash}")
  static Future<String> generateSalt() async {
    if (_cachedSalt != null) return _cachedSalt!;

    const packageName = 'com.example.health_connect'; // From pubspec.yaml
    final firstCommitHash = await _getFirstCommitHash();
    
    final input = '$packageName:$firstCommitHash';
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes);
    
    _cachedSalt = hash.toString().toLowerCase();
    return _cachedSalt!;
  }

  /// Gets the first commit hash from git history
  static Future<String> _getFirstCommitHash() async {
    try {
      final process = await Process.run('git', ['rev-list', '--max-parents=0', 'HEAD']);
      if (process.exitCode == 0) {
        final hash = (process.stdout as String).trim();
        return hash;
      }
      throw Exception('Failed to get first commit hash');
    } catch (e) {
      throw Exception('Failed to get first commit hash: $e');
    }
  }

  /// Verifies if the provided salt matches the expected salt
  static Future<bool> verifySalt(String providedSalt) async {
    final expectedSalt = await generateSalt();
    return providedSalt.toLowerCase() == expectedSalt;
  }

  /// Gets the package name from pubspec.yaml
  static Future<String> getPackageName() async {
    try {
      final file = File('pubspec.yaml');
      final content = await file.readAsString();
      final lines = content.split('\n');
      for (final line in lines) {
        if (line.startsWith('name:')) {
          return line.split(':')[1].trim();
        }
      }
      throw Exception('Package name not found in pubspec.yaml');
    } catch (e) {
      throw Exception('Failed to read package name: $e');
    }
  }
}