import 'package:flutter/material.dart';
import 'dart:math';
import 'homee_page.dart'; // استيراد الصفحة الجديدة

class MotivationalMessagesPage extends StatefulWidget {
  @override
  _MotivationalMessagesPageState createState() =>
      _MotivationalMessagesPageState();
}

class _MotivationalMessagesPageState extends State<MotivationalMessagesPage> {
  final List<String> motivationalMessages = [
    "You are stronger than you think. Never give up!",
    "Every day is a new chance to grow and improve.",
    "Nothing is impossible—keep trying!",
    "Hardships shape you into a stronger and more creative person.",
    "Believe in yourself. You deserve happiness and success!",
    "Every moment is a step toward a better life.",
    "Success starts with believing in yourself.",
    "Your dreams are worth chasing. Don't let doubt stop you.",
    "Change begins within you. Be the person you want to be.",
    "Keep moving forward even when the road is tough—you can do it!",
  ];

  String getRandomMessage() {
    final random = Random();
    return motivationalMessages[random.nextInt(motivationalMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA1E1F7), // لون الخلفية
      appBar: AppBar(
        title: Text("Motivational Messages"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Text(
                  getRandomMessage(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {}); // تحديث الرسالة عند النقر
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text("New Message"),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeePage()), // تغيير الوجهة إلى HomeePage
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text("Next"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
