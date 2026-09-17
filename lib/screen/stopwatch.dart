import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_teori_tugas3/theme/app_theme.dart';

class Stopwatch extends StatefulWidget {
  const Stopwatch({super.key});

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  Timer? _timer;
  final List<int> _laps = [];

  // ===== START / RESUME =====
  void _startTimer() {
    if (_isRunning) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _elapsedSeconds++);
    });
  }

  // ===== PAUSE (berhenti sementara, waktu tetap) =====
  void _pauseTimer() {
    if (!_isRunning) return;

    setState(() => _isRunning = false);
    _timer?.cancel();
  }

  // ===== RESET (balik ke 0) =====
  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _elapsedSeconds = 0;
      _laps.clear();
    });
  }

  // ===== LAP =====
  void _addLap() {
    if (_elapsedSeconds == 0) return;
    setState(() => _laps.insert(0, _elapsedSeconds));
  }

  // ===== FORMAT =====
  String get _formattedTime {
    final h = (_elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((_elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formatLap(int total) {
    final h = (total ~/ 3600).toString().padLeft(2, '0');
    final m = ((total % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      _formattedTime,
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
              // 👈 Tengahin
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ), // 👈 MAX WIDTH
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
                        final sec = _laps[index];
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
                            _formatLap(sec),
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
