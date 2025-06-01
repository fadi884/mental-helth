import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // مكتبة تشغيل الصوتيات

class RelaxScreen extends StatefulWidget {
  @override
  _RelaxScreenState createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  final player = AudioPlayer(); // مشغل الصوت
  bool isPlaying = false;
  double _currentVolume = 0.5; // قيمة مبدئية لمستوى الصوت (0.0 - 1.0)

  @override
  void initState() {
    super.initState();
    // تهيئة مستوى الصوت عند بدء الشاشة
    player.setVolume(_currentVolume);
  }

  // دالة لتشغيل/إيقاف الصوت
  void playSound() async {
    if (!isPlaying) {
      await player.play(AssetSource('assets/sounds/relaxxWeb.mp3')); // تشغيل الصوت
      setState(() => isPlaying = true);
    } else {
      await player.stop(); // إيقاف الصوت
      setState(() => isPlaying = false);
    }
  }

  // دالة لتغيير مستوى الصوت
  void _changeVolume(double newVolume) {
    setState(() {
      _currentVolume = newVolume;
    });
    player.setVolume(newVolume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "وضع الاسترخاء",
          style: TextStyle(color: Colors.white), // لون أبيض للعنوان
        ),
        backgroundColor: Colors.transparent, // جعل شريط التطبيق شفافاً
        elevation: 0, // إزالة الظل من شريط التطبيق
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // أيقونة بيضاء للرجوع
          onPressed: () {
            Navigator.pop(context); // الرجوع إلى الشاشة السابقة
          },
        ),
      ),
      extendBodyBehindAppBar: true, // لجعل الخلفية تمتد خلف الـ AppBar
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              "assets/images/relax_background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // تراكب شفاف لجعل النص والأزرار أكثر وضوحًا
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // 40% شفافية للون الأسود
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "استرخِ واستمتع بالهدوء",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, // حجم أكبر للنص
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // جعل النص سميكًا
                    shadows: [ // إضافة ظل خفيف للنص
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40), // مسافة أكبر
                // زر التشغيل/الإيقاف الأنيق
                FloatingActionButton(
                  onPressed: playSound,
                  backgroundColor: Colors.blueAccent.withOpacity(0.8), // لون أزرق فاتح مع شفافية
                  foregroundColor: Colors.white, // لون الأيقونة أبيض
                  elevation: 8, // رفع الزر لإعطاء ظل
                  heroTag: "playPauseButton", // مهم إذا كان لديك أكثر من FloatingActionButton
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow, // تبديل الأيقونة
                    size: 48, // حجم كبير للأيقونة
                  ),
                ),
                SizedBox(height: 30), // مسافة بين الزر وشريط الصوت
                // شريط تمرير للتحكم في مستوى الصوت
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      Icon(Icons.volume_down, color: Colors.white.withOpacity(0.8)),
                      Expanded(
                        child: Slider(
                          value: _currentVolume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10, // 10 درجات لضبط الصوت
                          activeColor: Colors.blueAccent, // لون الشريط النشط
                          inactiveColor: Colors.white.withOpacity(0.3), // لون الشريط غير النشط
                          onChanged: _changeVolume,
                        ),
                      ),
                      Icon(Icons.volume_up, color: Colors.white.withOpacity(0.8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose(); // مهم لتحرير موارد مشغل الصوت عند الخروج من الشاشة
    super.dispose();
  }
}