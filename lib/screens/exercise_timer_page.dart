import 'package:flutter/material.dart';
import 'dart:async'; // لاستخدام Timer

class ExerciseTimerPage extends StatefulWidget {
  final String exerciseName;
  final int durationInSeconds;

  const ExerciseTimerPage({
    Key? key,
    required this.exerciseName,
    required this.durationInSeconds,
  }) : super(key: key);

  @override
  _ExerciseTimerPageState createState() => _ExerciseTimerPageState();
}

class _ExerciseTimerPageState extends State<ExerciseTimerPage> {
  late int _remainingSeconds; // الوقت المتبقي بالثواني
  Timer? _timer; // مؤقت Flutter

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) { // تحقق إذا كانت الـ widget ما زالت موجودة لتجنب الأخطاء بعد العودة
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel(); // إيقاف المؤقت
          _onTimerEnd(); // استدعاء دالة عند انتهاء المؤقت
        }
      });
    });
  }

  void _onTimerEnd() {
    // عرض رسالة اكتمال قصيرة
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('أحسنت! لقد أكملت ${widget.exerciseName}!'),
        duration: Duration(seconds: 2), // تظهر لمدة 2 ثانية
      ),
    );
    // العودة تلقائياً إلى صفحة تمارين الطاقة
    Navigator.pop(context);
  }

  // دالة لتنسيق الوقت للعرض (MM:SS)
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _timer?.cancel(); // إلغاء المؤقت إذا تم الخروج من الصفحة قبل انتهائه
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.exerciseName, // عنوان الواجهة هو اسم التمرين
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // إزالة زر العودة التلقائي للسماح للمؤقت بالانتهاء أو التحكم في العودة يدويًا
        automaticallyImplyLeading: false,
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
                Text(
                  "الوقت المتبقي:",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                SizedBox(height: 20),
                // عرض المؤقت
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue.shade700,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // زر لإيقاف التمرين يدوياً (اختياري)
                ElevatedButton.icon(
                  onPressed: () {
                    _timer?.cancel(); // إيقاف المؤقت
                    Navigator.pop(context); // العودة يدوياً
                  },
                  icon: Icon(Icons.stop),
                  label: Text('إيقاف التمرين'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}