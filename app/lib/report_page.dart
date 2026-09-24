import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportPage extends StatefulWidget {
  final String name;
  const ReportPage({super.key, required this.name});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _picker = ImagePicker();
  final _noteCtrl = TextEditingController();

  String? _checkpoint;
  XFile? _photo;
  bool _finding = false;
  bool _sending = false;

  bool get _hasCamera => Platform.isAndroid || Platform.isIOS;

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

    // ⚠️ TODO: ganti pakai API
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _sending = false);

    // Tampilkan konfirmasi
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Laporan berhasil dikirim.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // balik ke home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Laporan')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Checkpoint
              DropdownButtonFormField<String>(
                value: _checkpoint,
                decoration: const InputDecoration(
                  labelText: 'Lokasi / Checkpoint',
                  prefixIcon: Icon(Icons.place_outlined),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Gerbang Depan',
                    child: Text('Gerbang Depan'),
                  ),
                  DropdownMenuItem(
                    value: 'Pos Utama',
                    child: Text('Pos Utama'),
                  ),
                  DropdownMenuItem(value: 'Lobby', child: Text('Lobby')),
                  DropdownMenuItem(value: 'Gudang A', child: Text('Gudang A')),
                  DropdownMenuItem(value: 'Parkiran', child: Text('Parkiran')),
                  DropdownMenuItem(value: 'Rooftop', child: Text('Rooftop')),
                ],
                onChanged: _sending
                    ? null
                    : (v) => setState(() => _checkpoint = v),
              ),
              const SizedBox(height: 16),

              // Foto
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
                                    : 'Ketuk untuk pilih foto',
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

              // Status
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

              // Catatan
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
              const SizedBox(height: 20),

              // Tombol kirim
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
                  label: Text(_sending ? 'Mengirim...' : 'Kirim Laporan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
