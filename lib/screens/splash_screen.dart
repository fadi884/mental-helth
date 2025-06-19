import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// تم إزالة استيراد Lottie لأنه لم يعد مستخدماً
// import 'package:lottie/lottie.dart'; 

import 'home.dart'; // تأكد من أن هذا المسار صحيح لشاشة تسجيل الدخول أو الشاشة الرئيسية الأولى

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key); // إضافة const constructor

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // تهيئة متحكم الأنميشن
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // مدة ظهور واختفاء الشعار والنص (يمكن أن تكون أقصر إذا أردت)
    );

    // تعريف أنيميشن التلاشي
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn, // تأثير ظهور سلس
      ),
    );

    // بدء الأنميشن
    _animationController.forward();

    // الانتقال إلى الشاشة التالية بعد انتهاء الأنميشن وفترة تأخير إضافية
    // **تم تعديل المدة هنا إلى 10 ثوانٍ**
    Future.delayed(const Duration(seconds: 10), () { 
      if (mounted) { // التأكد من أن الـ Widget ما زال موجوداً
        Navigator.pushReplacement(
          context,
          // استخدام FadeRouteBuilder لانتقال سلس إلى Home
          FadeRouteBuilder(page: const Home()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // التخلص من متحكم الأنميشن
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // خلفية متدرجة (يمكنك تعديل الألوان لتناسب تصميمك)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF26C6DA), Color(0xFFE0F7FA)], // ألوان زاهية ومهدئة
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition( // تطبيق تأثير التلاشي على المحتوى
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // **تم استبدال Lottie Animation بصورتك المحلية**
              Image.asset(
                'assets/logo.png', // مسار صورتك المحلية
                width: MediaQuery.of(context).size.width * 0.6, // حجم متجاوب
                height: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.contain, // لجعل الصورة تتناسب داخل المساحة مع الحفاظ على نسبة الأبعاد
              ),
              const SizedBox(height: 30),
              // اسم التطبيق أو شعار
              Text(
                "تطبيق الاسترخاء والحياة الصحية", // اسم تطبيقك
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // لون أبيض ساطع
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "رفيقك نحو الهدوء والسكينة", // شعار قصير
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9), // لون أبيض شبه شفاف
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// كلاس مساعد لإنشاء انتقال Fade (يمكن وضعه في ملف منفصل إذا كنت تستخدمه بكثرة)
class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
