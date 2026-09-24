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
}

class AuthService {
  static String? _token;
  static UserModel? currentUser;
  static const _dummyUsers = {
    'security1': {
      'password': '123456',
      'name': 'Budi Santoso',
      'role': 'security',
    },
    'security2': {
      'password': '123456',
      'name': 'Andi Wijaya',
      'role': 'security',
    },
    'admin1': {'password': '123456', 'name': 'Admin', 'role': 'admin'},
  };

  Future<void> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _dummyUsers[username];

    if (user == null) {
      throw AuthException('Username tidak ditemukan');
    }

    if (user['password'] != password) {
      throw AuthException('Password salah');
    }

    _token = 'dummy-token-$username';
    currentUser = UserModel(
      username: username,
      name: user['name']!,
      role: user['role']!,
    );
  }

  Future<String?> getToken() async => _token;

  Future<void> logout() async {
    _token = null;
    currentUser = null;
  }
}
