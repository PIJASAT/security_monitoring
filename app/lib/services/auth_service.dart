import 'package:dio/dio.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class UserModel {
  final String username;
  final String name;
  final String role;

  const UserModel({
    required this.username,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'security',
    );
  }
}

class AuthService {
  // Masukkan Base URL API temen kamu di sini (misal: http://192.168.1.10:8000/api)
  static const String _baseUrl = 'https://api-temen-lu.com/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static String? _token;
  static UserModel? currentUser;

  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Sesuaikan key JSON ('token' & 'user') dengan format respon API temen lu
        _token = data['token'];
        currentUser = UserModel.fromJson(data['user']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Mengambil pesan error dari Backend (misal: {"message": "Password salah"})
        final message = e.response?.data['message'] ?? 'Gagal melakukan login';
        throw AuthException(message);
      } else {
        throw AuthException(
          'Gagal terhubung ke server. Periksa koneksi internet.',
        );
      }
    } catch (e) {
      throw AuthException('Terjadi kesalahan yang tidak diketahui');
    }
  }

  Future<String?> getToken() async => _token;

  Future<void> logout() async {
    _token = null;
    currentUser = null;
  }
}
