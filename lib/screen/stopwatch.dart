import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_teori_tugas3/theme/app_theme.dart';

class Stopwatch extends StatefulWidget {
  const Stopwatch({super.key});

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  // ===== STATE BARU =====
  Duration _elapsed = Duration.zero; // Total waktu yang udah jalan
  DateTime? _startTime; // Waktu mulai (saat running)
  bool _isRunning = false;
  Timer? _timer;
  final List<Duration> _laps = []; // Simpan Duration, bukan int

  // ===== START / RESUME =====
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      // 👇 Simpan waktu mulai = sekarang - waktu yang udah jalan
      _startTime = DateTime.now().subtract(_elapsed);
    });

    // Timer cuma buat refresh UI tiap detik
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) setState(() {});
    });
  }

  // ===== PAUSE =====
  void _pauseTimer() {
    if (!_isRunning) return;

    setState(() {
      _isRunning = false;
      // 👇 Simpan total waktu yang udah jalan
      if (_startTime != null) {
        _elapsed = DateTime.now().difference(_startTime!);
      }
      _startTime = null;
    });
    _timer?.cancel();
  }

  // ===== RESET =====
  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _elapsed = Duration.zero;
      _laps.clear();
      _startTime = null;
    });
  }

  // ===== LAP =====
  void _addLap() {
    Duration current = _getCurrentDuration();
    if (current.inSeconds == 0) return;
    setState(() => _laps.insert(0, current));
  }

  // ===== HITUNG DURASI SEKARANG =====
  Duration _getCurrentDuration() {
    if (_isRunning && _startTime != null) {
      return DateTime.now().difference(_startTime!);
    }
    return _elapsed;
  }

  // ===== FORMAT =====
  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDuration = _getCurrentDuration();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: AppTheme.background,
        child: Column(
          children: [
            // ===== TAMPILAN WAKTU =====
            Expanded(
              flex: 2,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _formatDuration(currentDuration),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ===== TOMBOL =====
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildControlButton(
                          _isRunning ? 'Pause' : 'Start',
                          _isRunning ? Colors.orange : Colors.green,
                          _isRunning ? _pauseTimer : _startTimer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildControlButton(
                          'Lap',
                          AppTheme.primaryLight,
                          _addLap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildControlButton(
                          'Reset',
                          AppTheme.error,
                          _resetTimer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ===== DAFTAR LAP =====
            Expanded(
              flex: 3,
              child: _laps.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada lap',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _laps.length,
                      itemBuilder: (context, index) {
                        final lapNum = _laps.length - index;
                        final lapDur = _laps[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryDark,
                            child: Text(
                              '$lapNum',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text('Lap $lapNum'),
                          trailing: Text(
                            _formatDuration(lapDur),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        minimumSize: const Size(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
