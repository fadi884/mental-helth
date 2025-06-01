import 'package:flutter/material.dart';
import 'home.dart'; // تأكد من تعديل المسار الصحيح

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logo.png"), // عرض الصورة كشاشة كاملة
            fit: BoxFit.cover, // جعل الصورة تمتد لتغطي الشاشة بالكامل
          ),
        ),
      ),
    );
  }
}
