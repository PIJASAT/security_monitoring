import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  // Emulator Android: 10.0.2.2 = localhost komputer kamu.
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      final res = await _dio.post(
        '/login',
        data: {'username': username, 'password': password},
      );

      final token = res.data['token'] as String?;
      if (token == null) throw AuthException('Respons server tidak valid');

      await _storage.write(key: 'token', value: token);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw AuthException('Tidak ada koneksi ke server');
      }

      final status = e.response?.statusCode;
      final data = e.response?.data;
      final serverMsg = data is Map ? data['message'] as String? : null;

      if (status == 401 || status == 422) {
        throw AuthException(serverMsg ?? 'Username atau password salah');
      }
      if (status == 403) {
        throw AuthException(serverMsg ?? 'Akun nonaktif atau tidak diizinkan');
      }
      throw AuthException('Terjadi kesalahan, coba lagi');
    }
  }

  Future<String?> getToken() => _storage.read(key: 'token');

  Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await _dio.post(
          '/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (_) {
      // Abaikan error jaringan, token lokal tetap dihapus.
    } finally {
      await _storage.delete(key: 'token');
    }
  }
}
