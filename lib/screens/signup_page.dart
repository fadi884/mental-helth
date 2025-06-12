import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'Questionnaire_page.dart';
import 'home.dart'; // Import the Home page for back navigation

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key); // Added const constructor
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _registerUser() async {
    final String apiUrl = "http://127.0.0.1:8000/api/register";

    // Basic client-side validation
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("الرجاء تعبئة جميع الحقول."),
            backgroundColor: Colors.orange.shade400,
          ),
        );
      }
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("كلمة المرور وتأكيد كلمة المرور غير متطابقين."),
            backgroundColor: Colors.orange.shade400,
          ),
        );
      }
      return;
    }
    
    // Add a simple email regex check (optional but good practice)
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("الرجاء إدخال بريد إلكتروني صالح."),
            backgroundColor: Colors.orange.shade400,
          ),
        );
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "password_confirmation": _confirmPasswordController.text.trim(),
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إنشاء الحساب بنجاح! 🎉")),
          );
          // Navigate to Questionnaire Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuestionnairePage()), // **REMOVED const HERE**
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("خطأ: ${responseData['message'] ?? 'حدث خطأ غير متوقع'}"),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ في الشبكة: تعذر الاتصال بالخادم. الرجاء التحقق من اتصالك وحالة الخادم. ($e)"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind AppBar for gradient effect
      appBar: AppBar(
        title: Text(
          "إنشاء حساب جديد", // Arabic title
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)], // AppBar gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove AppBar shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back to the login page (Home)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()), // Assumes Home has const constructor
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // Background gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0), // Added vertical padding
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withOpacity(0.95), // Semi-transparent white card
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "أهلاً بك!", // Welcome message
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0288D1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "اسم المستخدم", // Arabic label
                        hintText: "أدخل اسم المستخدم الخاص بك", // Arabic hint
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF0288D1)),
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "البريد الإلكتروني", // Arabic label
                        hintText: "أدخل بريدك الإلكتروني", // Arabic hint
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
                        labelText: "كلمة المرور", // Arabic label
                        hintText: "أدخل كلمة مرور قوية", // Arabic hint
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
                    const SizedBox(height: 15),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "تأكيد كلمة المرور", // Arabic label
                        hintText: "أعد إدخال كلمة المرور", // Arabic hint
                        prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF0288D1)),
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
                        onPressed: _registerUser,
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
                          "إنشاء حساب", // Arabic button text
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()), // Navigate back to login
                        );
                      },
                      child: Text(
                        "هل لديك حساب بالفعل؟ تسجيل الدخول", // Arabic text
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
          ),
        ),
      ),
    );
  }
}