import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/gradient_background.dart';
import '../services/firestore_services.dart';
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
  final _firestoreService = FirestoreService();

  late final TextEditingController _namaKonserController;
  late final TextEditingController _namaGrupController;
  late final TextEditingController _venueController;
  late final TextEditingController _kapasitasController;
  late final TextEditingController _terjualController;
  late final TextEditingController _hargaController;

  DateTime? _tanggal;
  String _status = 'akan_datang';
  String? _agensiId;

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

    _tanggal = konser?.tanggal;
    _status = konser?.status ?? 'akan_datang';
    _agensiId = konser?.agensiId;

    _futureAgensi = _muatAgensi();

    // Setiap kapasitas berubah, validasi ulang field tiket terjual
    // (karena batas atasnya bergantung ke nilai kapasitas)
    _kapasitasController.addListener(() {
      _formKey.currentState?.validate();
    });
  }

  Future<List<AgensiModel>> _muatAgensi() async {
    final data = await _firestoreService.getAllAgensi();
    return data.map((item) => AgensiModel.fromMap(item)).toList();
  }

  @override
  void dispose() {
    _namaKonserController.dispose();
    _namaGrupController.dispose();
    _venueController.dispose();
    _kapasitasController.dispose();
    _terjualController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return '';
    return '${tanggal.year.toString().padLeft(4, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.day.toString().padLeft(2, '0')}';
  }

  // ---- Validator kapasitas: wajib angka bulat > 0 ----
  String? _validasiKapasitas(String? value) {
    final kapasitas = int.tryParse(value ?? '');
    if (kapasitas == null) return 'Isi dengan angka';
    if (kapasitas <= 0) return 'Kapasitas harus lebih dari 0';
    return null;
  }

  // ---- Validator tiket terjual: angka bulat >= 0 DAN <= kapasitas ----
  String? _validasiTerjual(String? value) {
    final terjual = int.tryParse(value ?? '');
    if (terjual == null) return 'Isi dengan angka';
    if (terjual < 0) return 'Tidak boleh negatif';

    final kapasitas = int.tryParse(_kapasitasController.text);
    if (kapasitas != null && terjual > kapasitas) {
      return 'Tidak boleh lebih dari kapasitas ($kapasitas)';
    }
    return null;
  }

  // ---- Validator harga tiket: angka >= 0 ----
  String? _validasiHarga(String? value) {
    final harga = double.tryParse(value ?? '');
    if (harga == null) return 'Isi dengan angka';
    if (harga < 0) return 'Tidak boleh negatif';
    return null;
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_agensiId == null) {
      setState(() => _errorMessage = 'Pilih agensi terlebih dahulu');
      return;
    }
    if (_tanggal == null) {
      setState(() => _errorMessage = 'Pilih tanggal konser terlebih dahulu');
      return;
    }

    final kapasitas = int.parse(_kapasitasController.text);
    final terjual = int.parse(_terjualController.text);
    final harga = double.parse(_hargaController.text);

    // Jaga-jaga tambahan di luar validator form, kalau-kalau ada
    // jalur lain yang melewati validasi (misal isi lewat kode lain).
    if (terjual > kapasitas) {
      setState(
        () => _errorMessage = 'Tiket terjual tidak boleh lebih dari kapasitas',
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    // Cari nama agensi terpilih, biar disimpan juga (memudahkan tampilan list)
    final daftarAgensi = await _futureAgensi;
    final agensiTerpilih = daftarAgensi.firstWhere((a) => a.id == _agensiId);

    try {
      if (widget.isEdit) {
        await _firestoreService.updateKonser(
          id: widget.konser!.id,
          agensiId: _agensiId!,
          namaAgensi: agensiTerpilih.namaAgensi,
          namaKonser: _namaKonserController.text.trim(),
          namaGrup: _namaGrupController.text.trim(),
          tanggal: _tanggal!,
          venue: _venueController.text.trim(),
          kapasitas: kapasitas,
          tiketTerjual: terjual,
          hargaTiket: harga,
          status: _status,
        );
      } else {
        await _firestoreService.tambahKonser(
          agensiId: _agensiId!,
          namaAgensi: agensiTerpilih.namaAgensi,
          namaKonser: _namaKonserController.text.trim(),
          namaGrup: _namaGrupController.text.trim(),
          tanggal: _tanggal!,
          venue: _venueController.text.trim(),
          kapasitas: kapasitas,
          tiketTerjual: terjual,
          hargaTiket: harga,
          status: _status,
        );
      }

      setState(() => _isSaving = false);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Gagal menyimpan data: $e';
      });
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    return DropdownButtonFormField<String>(
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
                  readOnly: true,
                  controller: TextEditingController(
                    text: _formatTanggal(_tanggal),
                  ),
                  onTap: _pilihTanggal,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  validator: (_) => _tanggal == null ? 'Wajib diisi' : null,
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
                  validator: _validasiKapasitas,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _terjualController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tiket Terjual',
                    helperText: 'Tidak boleh lebih dari kapasitas',
                  ),
                  validator: _validasiTerjual,
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
                  validator: _validasiHarga,
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
