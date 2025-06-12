import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'signup_page.dart';
import 'motivational_messages.dart'; // Assuming MotivationalMessagesPage is the class name

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key); // Add const constructor for Home itself
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Faster fade-in
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  Future<void> _loginUser() async {
    final String apiUrl = "http://127.0.0.1:8000/api/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful! 🎉")),
          );
          // Redirect to Motivational Messages Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MotivationalMessagesPage()), // **REMOVED const HERE**
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${responseData['message'] ?? 'Login failed. Please check your credentials.'}"),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error: Could not connect to the server. Please check your connection and server status. ($e)"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "مرحباً بك!",
                            style: GoogleFonts.cairo(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0288D1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "البريد الإلكتروني",
                              hintText: "أدخل بريدك الإلكتروني",
                              prefixIcon: const Icon(Icons.email, color: Color(0xFF0288D1)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF0288D1), width: 2),
                              ),
                            ),
                            style: GoogleFonts.cairo(),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "كلمة المرور",
                              hintText: "أدخل كلمة المرور",
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF0288D1)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF0288D1), width: 2),
                              ),
                            ),
                            style: GoogleFonts.cairo(),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loginUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0288D1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "تسجيل الدخول",
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()), // **REMOVED const HERE**
                              );
                            },
                            child: Text(
                              "لا تمتلك حساب؟ أنشئ حسابًا",
                              style: GoogleFonts.cairo(
                                color: const Color(0xFF0288D1),
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}