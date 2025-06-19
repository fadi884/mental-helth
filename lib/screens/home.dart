import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // تم تصحيح هذا السطر
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:shared_preferences/shared_preferences.dart'; // استيراد SharedPreferences

import 'signup_page.dart';
import 'dashboard_page.dart'; // استيراد صفحة لوحة التحكم

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key); // إضافة const constructor لـ Home نفسها
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false; // لإدارة حالة التحميل وزر تسجيل الدخول

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // تلاشي سريع للواجهة
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
    _checkLoginStatus(); // التحقق من حالة تسجيل الدخول عند بدء التطبيق
  }

  // دالة للتحقق مما إذا كان المستخدم مسجلاً بالفعل
  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    final int? userId = prefs.getInt('user_id');
    final List<String>? userRoles = prefs.getStringList('user_roles');

    // إذا كان هناك توكن وبيانات مخزنة، قم بتوجيه المستخدم مباشرة إلى لوحة التحكم
    if (accessToken != null && userId != null && userRoles != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()), // توجيه إلى DashboardPage
      );
    }
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true; // بدء التحميل لإظهار مؤشر التقدم
    });

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
        // استلام البيانات من الـ Backend
        final String accessToken = responseData['access_token'];
        final Map<String, dynamic> userData = responseData['user'];
        final int userId = userData['id'];
        final String userName = userData['name'];
        final String userEmail = userData['email'];
        final List<String> userRoles = List<String>.from(userData['roles']); // جلب الأدوار

        // تخزين البيانات في SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setInt('user_id', userId);
        await prefs.setString('user_name', userName);
        await prefs.setString('user_email', userEmail);
        await prefs.setStringList('user_roles', userRoles); // تخزين الأدوار كقائمة من الـ Strings

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login successful! 🎉 مرحباً بك, $userName! دورك: ${userRoles.join(', ')}",
              style: GoogleFonts.cairo(),
              ),
              backgroundColor: Colors.green.shade400,
            ),
          );
          // توجيه المستخدم إلى DashboardPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      } else {
        // معالجة الأخطاء من الـ Backend
        if (mounted) {
          String errorMessage = responseData['message'] ?? 'Login failed. Please check your credentials.';
          if (responseData['messages'] != null && responseData['messages'] is Map) {
            Map<String, dynamic> messagesMap = responseData['messages'];
            List<String> validationErrors = [];
            messagesMap.forEach((field, messages) {
              if (messages is List) {
                validationErrors.addAll(messages.map((msg) => msg.toString()));
              } else if (messages is String) {
                validationErrors.add(messages);
              }
            });
            if (validationErrors.isNotEmpty) {
              errorMessage += '\n' + validationErrors.join('\n');
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $errorMessage", style: GoogleFonts.cairo()),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      }
    } catch (e) {
      // معالجة أخطاء الشبكة أو الاتصال
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error: Could not connect to the server. Please check your connection and server status. ($e)", style: GoogleFonts.cairo()),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // إنهاء التحميل في كل الأحوال
      });
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
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)], // تدرج لوني جميل
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
                  // قسم الشعار
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
                          "assets/logo.png", // مسار شعارك المحلي
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // بطاقة تسجيل الدخول
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.95), // خلفية شبه شفافة
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
                              color: const Color(0xFF0288D1), // لون أزرق جذاب
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
                            obscureText: true, // لإخفاء كلمة المرور
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
                              onPressed: _isLoading ? null : _loginUser, // تعطيل الزر أثناء التحميل
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0288D1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5, // ظل جذاب للزر
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white) // مؤشر تحميل
                                  : Text(
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
                                MaterialPageRoute(builder: (context) => const SignupPage()), // الانتقال لصفحة التسجيل
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
