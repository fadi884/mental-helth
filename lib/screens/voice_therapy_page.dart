import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts
import 'package:lottie/lottie.dart'; // سنستخدم Lottie لإضافة أنيميشن المايك الاحترافي

// تأكد من إضافة lottie إلى pubspec.yaml:
// dependencies:
//   lottie: ^3.1.0 # أو أحدث إصدار

class VoiceTherapyPage extends StatefulWidget {
  const VoiceTherapyPage({Key? key}) : super(key: key);

  @override
  State<VoiceTherapyPage> createState() => _VoiceTherapyPageState();
}

class _VoiceTherapyPageState extends State<VoiceTherapyPage> {
  bool _isRecording = false; // حالة لتحديد ما إذا كان التسجيل جارياً

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // TODO: ابدأ عملية تسجيل الصوت
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'بدء التسجيل... تحدث الآن.',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.green.shade400,
        ),
      );
    } else {
      // TODO: أوقف عملية تسجيل الصوت ومعالجة الملف
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إيقاف التسجيل. جارٍ المعالجة...',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.blue.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "تفريغ الطاقة الصوتية",
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRecording ? "جارٍ الاستماع..." : "اضغط على المايك لتفريغ طاقتك",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isRecording ? Colors.red.shade700 : const Color(0xFF00796B),
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red.shade100 : Colors.blue.shade100,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _isRecording ? Colors.red.shade200 : Colors.blue.shade200,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: AnimatedCrossFade(
                      firstChild: Icon(
                        Icons.mic,
                        size: 80,
                        color: Colors.blue.shade800,
                      ),
                      secondChild: Lottie.network( // استخدام Lottie لأنيميشن المايك
                        'https://assets9.lottiefiles.com/packages/lf20_tkhb75t0.json', // أنيميشن مايك يتكلم (يمكنك البحث عن أنيميشن آخر)
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      crossFadeState: _isRecording ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                if (!_isRecording) // زر إضافي للتحكم (اختياري)
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'هنا يمكن إضافة ميزات أخرى مثل حفظ الصوت أو تحليله.',
                            style: GoogleFonts.cairo(),
                          ),
                          backgroundColor: Colors.grey.shade600,
                        ),
                      );
                    },
                    icon: const Icon(Icons.info, color: Colors.white),
                    label: Text(
                      "معلومات إضافية",
                      style: GoogleFonts.cairo(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}