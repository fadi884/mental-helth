import 'package:flutter/material.dart';

class BreathingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تمارين التنفس"),
        backgroundColor: Color(0xFF26C6DA), // لون متناسق مع الواجهة الرئيسية
      ),
      body: Center(
        child: Text(
          "هنا ستظهر تمارين التنفس قريبًا!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
