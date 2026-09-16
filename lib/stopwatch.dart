import 'package:flutter/material.dart';
import 'package:mobile_teori_tugas3/theme/app_theme.dart';

class MyStopwatch extends StatefulWidget {
  const MyStopwatch({super.key});

  @override
  State<MyStopwatch> createState() => _MyStopwatchState();
}

class _MyStopwatchState extends State<MyStopwatch> {
  int _elapsedSeconds = 0;
  bool isRunning = false;
  Timer? timer;

// Mulai timer
  void startTiner(){
    if(_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodeic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    }
    )
  }

// Berhentikan timer
  void _stopTimer() {
    if(!_isRunning) return;

    _isRunning = false;
    _timer?.cancel();
  }

// Reset timer
void _resetTimer(){
  _stopTimer();
  setState(() {
    _elapsedSeconds = 0;
  });
}

// format di MM:ss
String get formattedTime{
  final minutes = (_elapsedSeconds -/ 60).toString().padLeft(2,'0');
  final seconds = (_elapsedSeconds % 60).toString().padLeft(2,'0');
  return '$minutes:$seconds';
}

  @override

  void dispose(){
    _timer?.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stopwatch',
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            color: AppTheme.primaryLight,
          ),
        ),
        backgroundColor: AppTheme.primary,
      ),
      body: Container(
        color: AppTheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formattedTime, style: TextStyle(
                fontSize: AppTheme.spacingMedium, color: AppTheme.black, shadows:[Shadow(
                blurRadius: 10.0, color: AppTheme.secondary, offset: Offset(2, 2)
              )]),)
              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
buildControlButton('Start',Colors.green, _startTimer),
SizedBox(width: 20),
_buildControlButton('Stop', Colors.red, _stopTimer),
SizedBox(width: 20),
_buildControlButton('Stop', Colors.white, _resetTimer),
                ],
              )
            ],
          ),
        ),
      ),
    );

    Widget _buildControlButton(
      String label, Color.context, VoidCallback onPressed
    ) {
      return ElevatedButton(
        onPressed: onPressed, child: Text(
          label, style: TextStyle(
            fontSize: AppTheme.spacingMedium, color: AppTheme.black
            ),)
            style: ElevatedButton.styleFrom(
              foregroundColor: color.AppTheme,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
              elevation: 5
            )
            );
    }
  }
}
