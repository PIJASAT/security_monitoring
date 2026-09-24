import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:securityapp/models/login_page.dart';

class PhotoReport {
  final String checkpoint;
  final String note;
  final bool hasFinding;
  final String photoPath;
  final String securityName;
  final DateTime createdAt;

  const PhotoReport({
    required this.checkpoint,
    required this.note,
    required this.hasFinding,
    required this.photoPath,
    required this.securityName,
    required this.createdAt,
  });
}

final List<PhotoReport> _reports = [];

const _checkpoints = [
  'Gerbang Depan',
  'Pos Utama',
  'Lobby',
  'Gudang A',
  'Parkiran',
  'Rooftop',
];

String _two(int n) => n.toString().padLeft(2, '0');
String _hhmm(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';
String _dmy(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

void _logout(BuildContext context) {
  Navigator.of(
    context,
  ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
}

class HomePage extends StatelessWidget {
  final String name;
  final UserRole role;

  const HomePage({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return role == UserRole.admin
        ? AdminHome(name: name)
        : SecurityHome(name: name);
  }
}

class SecurityHome extends StatefulWidget {
  final String name;
  const SecurityHome({super.key, required this.name});

  @override
  State<SecurityHome> createState() => _SecurityHomeState();
}

class _SecurityHomeState extends State<SecurityHome> {
  final _picker = ImagePicker();
  final _noteCtrl = TextEditingController();

  String? _checkpoint;
  XFile? _photo;
  bool _finding = false;
  bool _sending = false;

  // Kamera hanya tersedia di HP. Di desktop (Windows) foto dipilih dari file
  // supaya tampilan tetap bisa dites.
  bool get _hasCamera => Platform.isAndroid || Platform.isIOS;

  List<PhotoReport> get _mine =>
      _reports.where((r) => r.securityName == widget.name).toList();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _msg(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _takePhoto() async {
    try {
      final file = await _picker.pickImage(
        source: _hasCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1600,
      );
      if (file != null && mounted) setState(() => _photo = file);
    } catch (_) {
      if (mounted) _msg('Tidak bisa mengambil foto. Periksa izin kamera.');
    }
  }

  Future<void> _submit() async {
    if (_checkpoint == null) {
      _msg('Pilih lokasi checkpoint dulu');
      return;
    }
    if (_photo == null) {
      _msg('Ambil foto dokumentasi dulu');
      return;
    }
    if (_finding && _noteCtrl.text.trim().isEmpty) {
      _msg('Catatan wajib diisi jika ada temuan');
      return;
    }

    setState(() => _sending = true);

    // Meniru waktu kirim ke server.
    await Future.delayed(const Duration(milliseconds: 800));

    _reports.insert(
      0,
      PhotoReport(
        checkpoint: _checkpoint!,
        note: _noteCtrl.text.trim(),
        hasFinding: _finding,
        photoPath: _photo!.path,
        securityName: widget.name,
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    setState(() {
      _sending = false;
      _checkpoint = null;
      _photo = null;
      _finding = false;
      _noteCtrl.clear();
    });
    _msg('Dokumentasi berhasil dikirim');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = _mine;
    final doneCheckpoints = mine.map((r) => r.checkpoint).toSet().length;
    final findings = mine.where((r) => r.hasFinding).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Security'),
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
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sapaan
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        child: Text(
                          widget.name.isEmpty
                              ? '?'
                              : widget.name[0].toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${widget.name}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(_dmy(DateTime.now())),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Progress checkpoint
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Progress checkpoint hari ini'),
                          Text(
                            '$doneCheckpoints/${_checkpoints.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: doneCheckpoints / _checkpoints.length,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Terkirim',
                      value: '${mine.length}',
                      icon: Icons.upload_file_outlined,
                    ),
                  ),
                  Expanded(
                    child: _StatCard(
                      label: 'Ada temuan',
                      value: '$findings',
                      icon: Icons.warning_amber_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Form dokumentasi
              Text(
                'Kirim Dokumentasi',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _checkpoint,
                decoration: const InputDecoration(
                  labelText: 'Lokasi / Checkpoint',
                  prefixIcon: Icon(Icons.place_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _checkpoints
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: _sending
                    ? null
                    : (v) => setState(() => _checkpoint = v),
              ),
              const SizedBox(height: 16),

              // Kotak foto
              GestureDetector(
                onTap: _sending ? null : _takePhoto,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: _photo == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _hasCamera
                                    ? 'Ketuk untuk ambil foto'
                                    : 'Ketuk untuk pilih foto (mode desktop)',
                              ),
                            ],
                          )
                        : Image.file(
                            File(_photo!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
              ),
              if (_photo != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _sending ? null : _takePhoto,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Ulangi foto'),
                  ),
                ),
              const SizedBox(height: 12),

              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.check_circle_outline),
                    label: Text('Aman'),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.warning_amber_rounded),
                    label: Text('Ada temuan'),
                  ),
                ],
                selected: {_finding},
                onSelectionChanged: _sending
                    ? null
                    : (s) => setState(() => _finding = s.first),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _noteCtrl,
                enabled: !_sending,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: _finding
                      ? 'Catatan temuan (wajib)'
                      : 'Catatan (opsional)',
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _sending ? null : _submit,
                  icon: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _sending ? 'Mengirim...' : 'Kirim Dokumentasi',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Riwayat kiriman
              Text(
                'Terkirim (${mine.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (mine.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Belum ada dokumentasi yang dikirim'),
                  ),
                )
              else
                ...mine.map(
                  (r) => _ReportTile(
                    report: r,
                    onTap: () => _showPhotoDialog(context, r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BERANDA ADMIN
// ---------------------------------------------------------------------------
class AdminHome extends StatefulWidget {
  final String name;
  const AdminHome({super.key, required this.name});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final findings = _reports.where((r) => r.hasFinding).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Admin'),
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
          constraints: const BoxConstraints(maxWidth: 560),
          child: RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Halo, ${widget.name}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(_dmy(DateTime.now())),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Dokumentasi masuk',
                        value: '${_reports.length}',
                        icon: Icons.photo_library_outlined,
                      ),
                    ),
                    Expanded(
                      child: _StatCard(
                        label: 'Ada temuan',
                        value: '$findings',
                        icon: Icons.warning_amber_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Kiriman Terbaru',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_reports.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Belum ada dokumentasi masuk.\n'
                        'Kirim dulu dari akun Security.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ..._reports.map(
                    (r) => _ReportTile(
                      report: r,
                      showSecurity: true,
                      onTap: () => _showPhotoDialog(context, r),
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

// ---------------------------------------------------------------------------
// KOMPONEN BERSAMA
// ---------------------------------------------------------------------------
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final PhotoReport report;
  final bool showSecurity;
  final VoidCallback? onTap;

  const _ReportTile({
    required this.report,
    this.showSecurity = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final time = _hhmm(report.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(report.photoPath),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported_outlined),
            ),
          ),
        ),
        title: Text(
          report.checkpoint,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(showSecurity ? '${report.securityName} • $time' : time),
        trailing: report.hasFinding
            ? const Icon(Icons.warning_amber_rounded, color: Colors.orange)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}

void _showPhotoDialog(BuildContext context, PhotoReport r) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Image.file(
                  File(r.photoPath),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.checkpoint,
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${r.securityName} • ${_dmy(r.createdAt)} ${_hhmm(r.createdAt)}',
                    ),
                    const SizedBox(height: 8),
                    Text(r.hasFinding ? 'Status: Ada temuan' : 'Status: Aman'),
                    if (r.note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Catatan: ${r.note}'),
                    ],
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
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
