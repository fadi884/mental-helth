import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts
import 'homee_page.dart'; // استيراد الصفحة الرئيسية الجديدة
import 'home.dart'; // استيراد صفحة تسجيل الدخول (Home)

class MotivationalMessagesPage extends StatefulWidget {
  // إضافة const constructor هنا لجعل هذه الصفحة قابلة للاستدعاء بـ const
  const MotivationalMessagesPage({Key? key}) : super(key: key);

  @override
  _MotivationalMessagesPageState createState() =>
      _MotivationalMessagesPageState();
}

class _MotivationalMessagesPageState extends State<MotivationalMessagesPage> {
  final List<String> motivationalMessages = [
    "أنت أقوى مما تتخيل. لا تستسلم أبداً!",
    "كل يوم هو فرصة جديدة للنمو والتطور.",
    "لا شيء مستحيل—استمر في المحاولة!",
    "الصعوبات تشكّلك لتصبح شخصاً أقوى وأكثر إبداعاً.",
    "آمن بنفسك. أنت تستحق السعادة والنجاح!",
    "كل لحظة هي خطوة نحو حياة أفضل.",
    "النجاح يبدأ بالإيمان بنفسك.",
    "أحلامك تستحق السعي وراءها. لا تدع الشك يوقفك.",
    "التغيير يبدأ من داخلك. كن الشخص الذي تريد أن تكونه.",
    "استمر في المضي قدماً حتى عندما يكون الطريق وعراً—يمكنك فعل ذلك!",
  ];

  late String _currentMessage; // استخدام late لتهيئة الرسالة في initState

  @override
  void initState() {
    super.initState();
    _currentMessage = getRandomMessage(); // تهيئة الرسالة عند بدء الصفحة
  }

  String getRandomMessage() {
    final random = Random();
    return motivationalMessages[random.nextInt(motivationalMessages.length)];
  }

  void _updateMessage() {
    setState(() {
      _currentMessage = getRandomMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // تمديد الجسم خلف الـ AppBar لجمالية التدرج
      appBar: AppBar(
        title: Text(
          "رسائل تحفيزية", // عنوان باللغة العربية
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)], // تدرج أزرق فاتح
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // شفافية الـ AppBar
        elevation: 0, // إزالة الظل
        leading: IconButton( // زر الرجوع
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // **التعديل هنا:** عند النقر على زر الرجوع، سيتم نقلك إلى صفحة Home
            Navigator.pushReplacement( // استخدام pushReplacement لمنع العودة إلى صفحة الرسائل من Home
              context,
              MaterialPageRoute(builder: (context) => const Home()), // استيراد صفحة Home (تسجيل الدخول)
            );
          },
        ),
      ),
      body: Container( // استخدام Container مع تدرج للخلفية
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // تدرج أزرق سماوي ناعم
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // زيادة الـ padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card( // استخدام Card لرسالة التحفيز
                  elevation: 12, // زيادة الظل
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // حواف أكثر استدارة
                  ),
                  color: Colors.white.withOpacity(0.95), // خلفية بيضاء شبه شفافة
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // padding داخلي للكارد
                    child: Text(
                      _currentMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo( // تطبيق خط Cairo
                        fontSize: 24, // زيادة حجم الخط
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade800, // لون نص داكن لتباين أفضل
                        height: 1.5, // مسافة بين السطور
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // زيادة المسافة
                SizedBox(
                  width: double.infinity, // جعل الزر يملأ العرض
                  child: ElevatedButton(
                    onPressed: _updateMessage, // استدعاء دالة تحديث الرسالة
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0288D1), // لون أزرق جذاب
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // حواف مستديرة للزر
                      ),
                      elevation: 8, // ظل للزر
                    ),
                    child: Text(
                      "رسالة جديدة", // نص الزر بالعربية
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // جعل الزر يملأ العرض
                  child: OutlinedButton( // استخدام OutlinedButton لزر "التالي"
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeePage()), // استخدام const هنا (إذا كان HomeePage لديه const constructor)
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0288D1), // لون النص
                      side: const BorderSide(color: Color(0xFF0288D1), width: 2), // حدود الزر
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0, // إزالة الظل
                    ),
                    child: Text(
                      "ابدأ الاستخدام", // نص الزر بالعربية
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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