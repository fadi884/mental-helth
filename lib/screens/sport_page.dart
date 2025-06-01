import 'package:flutter/material.dart';

class SportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التمارين الرياضية"),
        backgroundColor: Color(0xFF26C6DA), // لون متناسق مع الواجهة الرئيسية
      ),
      body: Center(
        child: Text(
          "هنا ستظهر محتويات التمارين الرياضية قريبًا!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
