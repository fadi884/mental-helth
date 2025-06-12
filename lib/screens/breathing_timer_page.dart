import 'package:flutter/material.dart';
import 'dart:async'; // لاستخدام Timer

class BreathingTimerPage extends StatefulWidget {
  final String exerciseName;
  final int durationInSeconds;

  const BreathingTimerPage({
    Key? key,
    required this.exerciseName,
    required this.durationInSeconds,
  }) : super(key: key);

  @override
  State<BreathingTimerPage> createState() => _BreathingTimerPageState();
}

class _BreathingTimerPageState extends State<BreathingTimerPage> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPaused = false; // لإدارة حالة الإيقاف المؤقت/الاستئناف

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && !_isPaused) {
        setState(() {
          _remainingSeconds--;
        });
      } else if (_remainingSeconds == 0) {
        timer.cancel();
        _showCompletionDialog();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.durationInSeconds;
      _isPaused = false;
    });
    _startTimer();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // يمنع إغلاق الحوار بالنقر خارجًا
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('أحسنت!'),
          content: Text('لقد أكملت تمرين "${widget.exerciseName}" بنجاح.'),
          actions: <Widget>[
            TextButton(
              child: const Text('العودة للصفحة الرئيسية'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
                Navigator.of(context).pop(); // العودة للصفحة السابقة (تمارين التنفس)
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // إلغاء المؤقت عند التخلص من الواجهة
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.exerciseName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // الخلفية: لون أزرق فاتح ثابت
          Positioned.fill(
            child: Container(
              color: Colors.lightBlue.shade100,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'الوقت المتبقي:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: (_remainingSeconds <= 10 && _remainingSeconds > 0)
                              ? Colors.red.shade700 // لون أحمر عند اقتراب النهاية
                              : Colors.green.shade700, // لون أخضر أثناء التمرين
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: 'pausePlayBtn', // حل مشكلة heroTag
                      onPressed: _togglePause,
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'resetBtn', // حل مشكلة heroTag
                      onPressed: _resetTimer,
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}