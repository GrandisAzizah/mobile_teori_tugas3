import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/konser_service.dart';
import '../models/konser_model.dart';
import '../models/agensi_model.dart';

class KonserFormPage extends StatefulWidget {
  final KonserModel? konser;

  const KonserFormPage({super.key, this.konser});

  bool get isEdit => konser != null;

  @override
  State<KonserFormPage> createState() => _KonserFormPageState();
}

class _KonserFormPageState extends State<KonserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _konserService = KonserService();

  late final TextEditingController _namaKonserController;
  late final TextEditingController _namaGrupController;
  late final TextEditingController _tanggalController;
  late final TextEditingController _venueController;
  late final TextEditingController _kapasitasController;
  late final TextEditingController _terjualController;
  late final TextEditingController _hargaController;

  String _status = 'akan_datang';
  int? _agensiId;

  late Future<List<AgensiModel>> _futureAgensi;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final konser = widget.konser;

    _namaKonserController = TextEditingController(
      text: konser?.namaKonser ?? '',
    );
    _namaGrupController = TextEditingController(text: konser?.namaGrup ?? '');
    _tanggalController = TextEditingController(text: konser?.tanggal ?? '');
    _venueController = TextEditingController(text: konser?.venue ?? '');
    _kapasitasController = TextEditingController(
      text: konser?.kapasitas.toString() ?? '',
    );
    _terjualController = TextEditingController(
      text: konser?.tiketTerjual.toString() ?? '0',
    );
    _hargaController = TextEditingController(
      text: konser?.hargaTiket.toString() ?? '',
    );

    _status = konser?.status ?? 'akan_datang';
    _agensiId = konser?.agensiId;

    _futureAgensi = _konserService.getAllAgensi();
  }

  @override
  void dispose() {
    _namaKonserController.dispose();
    _namaGrupController.dispose();
    _tanggalController.dispose();
    _venueController.dispose();
    _kapasitasController.dispose();
    _terjualController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final initialDate = DateTime.tryParse(_tanggalController.text) ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() => _tanggalController.text = formatted);
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_agensiId == null) {
      setState(() => _errorMessage = 'Pilih agensi terlebih dahulu');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final kapasitas = int.parse(_kapasitasController.text);
    final terjual = int.parse(_terjualController.text);
    final harga = double.parse(_hargaController.text);

    Map<String, dynamic> result;
    if (widget.isEdit) {
      result = await _konserService.editKonser(
        id: widget.konser!.id,
        agensiId: _agensiId!,
        namaKonser: _namaKonserController.text.trim(),
        namaGrup: _namaGrupController.text.trim(),
        tanggal: _tanggalController.text.trim(),
        venue: _venueController.text.trim(),
        kapasitas: kapasitas,
        tiketTerjual: terjual,
        hargaTiket: harga,
        status: _status,
      );
    } else {
      result = await _konserService.tambahKonser(
        agensiId: _agensiId!,
        namaKonser: _namaKonserController.text.trim(),
        namaGrup: _namaGrupController.text.trim(),
        tanggal: _tanggalController.text.trim(),
        venue: _venueController.text.trim(),
        kapasitas: kapasitas,
        tiketTerjual: terjual,
        hargaTiket: harga,
        status: _status,
      );
    }

    setState(() => _isSaving = false);
    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pop(context, true);
    } else {
      setState(
        () => _errorMessage = result['message'] ?? 'Gagal menyimpan data',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.isEdit ? 'Edit Konser' : 'Tambah Konser',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _namaKonserController,
                  decoration: const InputDecoration(labelText: 'Nama Konser'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _namaGrupController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Idol/Grup',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                FutureBuilder<List<AgensiModel>>(
                  future: _futureAgensi,
                  builder: (context, snapshot) {
                    final daftarAgensi = snapshot.data ?? [];
                    return DropdownButtonFormField<int>(
                      value: daftarAgensi.any((a) => a.id == _agensiId)
                          ? _agensiId
                          : null,
                      decoration: const InputDecoration(labelText: 'Agensi'),
                      items: daftarAgensi
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.namaAgensi),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _agensiId = value),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _tanggalController,
                  readOnly: true,
                  onTap: _pilihTanggal,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal (yyyy-MM-dd)',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _venueController,
                  decoration: const InputDecoration(labelText: 'Venue'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _kapasitasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Kapasitas'),
                  validator: (value) => (int.tryParse(value ?? '') == null)
                      ? 'Isi dengan angka'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _terjualController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Tiket Terjual'),
                  validator: (value) => (int.tryParse(value ?? '') == null)
                      ? 'Isi dengan angka'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _hargaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Harga Tiket (Rp)',
                  ),
                  validator: (value) => (double.tryParse(value ?? '') == null)
                      ? 'Isi dengan angka'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(
                      value: 'akan_datang',
                      child: Text('Akan Datang'),
                    ),
                    DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                    DropdownMenuItem(
                      value: 'dibatalkan',
                      child: Text('Dibatalkan'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _status = value ?? 'akan_datang'),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppTheme.spacingSmall),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppTheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppTheme.spacingLarge),
                ElevatedButton(
                  onPressed: _isSaving ? null : _simpan,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryDark,
                          ),
                        )
                      : Text(
                          widget.isEdit ? 'Simpan Perubahan' : 'Tambah Konser',
                        ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                ElevatedButton(
                  style: AppTheme.secondaryButtonStyle,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
