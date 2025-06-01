import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home.dart'; // إضافة صفحة تسجيل الدخول إذا كانت لديك

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.green, // تعديل الألوان لتكون متناسقة
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // تغيير الخط الافتراضي إذا كان لديك
      ),
      home: SplashScreen(), // الصفحة الأولى التي تظهر عند تشغيل التطبيق
      routes: {
        '/login': (context) => Home(), // تعريف صفحة تسجيل الدخول
      },
    );
  }
}
