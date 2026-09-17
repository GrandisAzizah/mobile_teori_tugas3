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
  List<int> _laps = [];

  // ===== START =====
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  // ===== STOP =====
  void _stopTimer() {
    if (!_isRunning) return;

    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  // ===== RESET =====
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _elapsedSeconds = 0;
      _laps.clear();
    });
  }

  // ===== LAP =====
  void _addLap() {
    if (_elapsedSeconds == 0) return;
    setState(() {
      _laps.add(_elapsedSeconds);
    });
  }

  // ===== FORMAT HH:MM:SS =====
  String get _formattedTime {
    final hours = (_elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // ===== FORMAT LAP (HH:MM:SS) =====
  String _formatLap(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
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
      ),
      body: Container(
        color: AppTheme.background,
        child: Column(
          children: [
            // ===== TAMPILAN WAKTU =====
            Expanded(
              flex: 2,
              child: Center(
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

            // ===== TOMBOL =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  _isRunning ? 'Pause' : 'Start',
                  _isRunning ? Colors.orange : Colors.green,
                  _isRunning ? _stopTimer : _startTimer,
                ),
                const SizedBox(width: 12),
                _buildControlButton('Lap', AppTheme.primaryLight, _addLap),
                const SizedBox(width: 12),
                _buildControlButton('Reset', AppTheme.error, _resetTimer),
              ],
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
                        final lapNum = index + 1;
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

  // ===== BUILDER TOMBOL =====
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
