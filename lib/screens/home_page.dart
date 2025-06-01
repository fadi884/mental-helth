import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الصفحة الرئيسية")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // تنفيذ إجراء عند النقر على الصورة
            print("تم النقر على الصورة!");
          },
          child: Image.asset(
            'assets/relax.png',
            width: 200,
            height: 200,
            fit: BoxFit.cover, // تحسين العرض بحيث تكون الصورة ملائمة تمامًا
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "الإعدادات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الملف الشخصي",
          ),
        ],
        onTap: (index) {
          // تنفيذ إجراء عند النقر على أيقونة
          print("تم النقر على العنصر رقم $index");
        },
      ),
    );
  }
}
