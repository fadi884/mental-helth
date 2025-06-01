import 'package:flutter/material.dart';

class InsomniaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نصائح للتغلب على الأرق"),
        backgroundColor: Color(0xFF26C6DA), // لون متناسق مع الواجهة الرئيسية
      ),
      body: Center(
        child: Text(
          "هنا ستظهر نصائح التغلب على الأرق قريبًا!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
