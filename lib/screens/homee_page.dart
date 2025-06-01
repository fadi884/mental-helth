import 'package:flutter/material.dart';
import 'home.dart';
import 'relax_page.dart';
import 'sport_page.dart';
import 'breathing_page.dart';
import 'insomnia_page.dart';
import 'community_page.dart'; // استيراد واجهة التواصل مع الآخرين

class HomeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF26C6DA),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == "account") {
                print("Account opened");
              } else if (value == "logout") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "account", child: Text("Account")),
              PopupMenuItem(value: "logout", child: Text("Logout")),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00796B),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Explore the app features and let us help you in your journey to relaxation and fitness.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 30),

              // Relaxation Card
              _buildCard(
                context,
                'assets/relax.png',
                "Start Your Relaxation Journey",
                "Tap here to experience meditation and tranquility sessions.",
                RelaxScreen(),
              ),

              SizedBox(height: 20),

              // Sports Card
              _buildCard(
                context,
                'assets/images/sport.png',
                "Start Your Workout",
                "Tap here to go to the fitness exercises page.",
                SportPage(),
              ),

              SizedBox(height: 20),

              // Breathing Exercises Card
              _buildCard(
                context,
                'assets/images/breathing.png',
                "Breathing Exercises",
                "Tap here to try deep breathing techniques for relaxation.",
                BreathingPage(),
              ),

              SizedBox(height: 20),

              // Insomnia Tips Card
              _buildCard(
                context,
                'assets/images/insomnia.png',
                "Tips for Overcoming Insomnia",
                "Tap here to get guidelines that help you sleep better.",
                InsomniaPage(),
              ),

              SizedBox(height: 20),

              // Community Interaction Card
              _buildCard(
                context,
                'assets/images/community.png',
                "Join the Community",
                "Tap here to connect with others and learn from their experiences.",
                CommunityPage(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF26C6DA),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            print("Survey page opened");
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Survey",
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String imagePath, String title, String description, Widget destination) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00796B),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
