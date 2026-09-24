import 'package:flutter/material.dart';
import 'package:securityapp/auth_service.dart';
import 'package:securityapp/login_page.dart';
import 'package:securityapp/report_page.dart';

class HomePage extends StatelessWidget {
  final String name;
  const HomePage({super.key, required this.name});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 48,
                  child: Text(
                    name.isEmpty ? '?' : name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
                const SizedBox(height: 24),

                // Sapaan
                Text(
                  'Selamat Datang,',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hati-hati, Tetsp Waspada',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),

                // Tombol ke form laporan
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ReportPage(name: name),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text(
                      'Buat Laporan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
