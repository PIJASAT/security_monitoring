class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class DummyUser {
  final String username;
  final String password;
  final String name;
  final String role;
  final bool active;

  const DummyUser({
    required this.username,
    required this.password,
    required this.name,
    required this.role,
    this.active = true,
  });
}

class AuthService {
  static const _users = [
    DummyUser(
      username: 'admin',
      password: 'admin123',
      name: 'Administrator',
      role: 'admin',
    ),
    DummyUser(
      username: 'security1',
      password: 'security123',
      name: 'Budi Santoso',
      role: 'security',
    ),
    DummyUser(
      username: 'security2',
      password: 'security123',
      name: 'Andi Nonaktif',
      role: 'security',
      active: false,
    ),
  ];

  static String? _token;
  static DummyUser? currentUser;

  Future<void> login(String username, String password) async {
    // Meniru waktu tunggu jaringan
    await Future.delayed(const Duration(seconds: 1));

    final matches = _users.where((u) => u.username == username);
    if (matches.isEmpty || matches.first.password != password) {
      throw AuthException('Username atau password salah');
    }

    final user = matches.first;
    if (!user.active) {
      throw AuthException('Akun nonaktif, hubungi admin');
    }

    currentUser = user;
    _token = 'dummy-token-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String?> getToken() async => _token;

  Future<void> logout() async {
    _token = null;
    currentUser = null;
  }
}
