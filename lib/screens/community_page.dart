import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community"),
        backgroundColor: Color(0xFF26C6DA), // متناسق مع الواجهة الرئيسية
      ),
      body: Center(
        child: Text(
          "This page will allow users to interact and share experiences soon!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
