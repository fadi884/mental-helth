import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import other pages for quick links
import 'daily_notes_page.dart';
import 'questionnaire_page.dart';
import 'diet_and_habit_page.dart';
import 'educational_resources_page.dart';
import 'motivational_messages.dart';
import 'phobia_page.dart'; // Assuming this is the correct import for the phobia page
import 'home.dart'; // For the login page after logout
import 'homee_page.dart'; // Import for the actual main home page

// New User Data Model for fetching user list in Admin Dashboard
class AppUser {
  final int id;
  final String name;
  final String email;
  final bool active;
  final List<String> roles; // List of role names

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.active,
    required this.roles,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      active: json['active'] == 1 || json['active'] == true, // Handle boolean/integer
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => role['name'] as String)
              .toList() ??
          [], // Extract role names
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = 'Guest';
  String _userEmail = '';
  List<String> _userRoles = [];
  bool _isLoading = true; // For loading user data initially

  List<AppUser> _allUsers = []; // List to store all users for admin
  bool _isFetchingAllUsers = false; // Loading state for fetching all users

  // API URL for logout and user management
  final String _apiUrl = "http://127.0.0.1:8000/api"; // Base API URL
  String? _authToken; // Declare _authToken here to be accessible

  SharedPreferences? _prefs; // **تمت الإضافة هنا: جعل prefs متغير عضو**

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchUsersIfNeeded();
  }

  Future<void> _loadUserDataAndFetchUsersIfNeeded() async {
    _prefs = await SharedPreferences.getInstance(); // **تمت التعديل هنا: تهيئة _prefs**
    setState(() {
      _userName = _prefs!.getString('user_name') ?? 'Guest';
      _userEmail = _prefs!.getString('user_email') ?? '';
      _userRoles = _prefs!.getStringList('user_roles') ?? [];
      _authToken = _prefs!.getString('access_token'); // Get the token
      _isLoading = false;
    });

    // If current user is admin, fetch all users
    if (_userRoles.contains('admin')) {
      await _fetchAllUsers();
    }
  }

  // Fetch all users for Admin
  Future<void> _fetchAllUsers() async {
    if (_authToken == null) {
      _showSnackBar('غير مصرح لك بالوصول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      return;
    }

    setState(() {
      _isFetchingAllUsers = true;
    });

    try {
      final response = await http.get(Uri.parse('$_apiUrl/users'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> usersData = data['users'];
        setState(() {
          _allUsers = usersData.map((json) => AppUser.fromJson(json)).toList();
        });
      } else if (response.statusCode == 401) {
        _showSnackBar('غير مصرح لك بالوصول إلى بيانات المستخدمين. الرجاء تسجيل الدخول.', Colors.red.shade600);
      } else {
        _showSnackBar('فشل جلب المستخدمين: ${response.statusCode}', Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الاتصال بجلب المستخدمين: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isFetchingAllUsers = false;
      });
    }
  }

  // Delete a user (Admin only)
  Future<void> _deleteUser(int userIdToDelete) async {
    if (_authToken == null) return; // Should not happen if admin is logged in

    setState(() {
      _isLoading = true; // Overall loading
    });

    try {
      final response = await http.delete(
        Uri.parse('$_apiUrl/users/$userIdToDelete'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('🗑️ تم حذف المستخدم بنجاح!', Colors.grey.shade600);
        _fetchAllUsers(); // Refresh the user list
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل حذف المستخدم: ${response.statusCode}';
        if (errorBody['message'] != null) {
          errorMessage += '\n' + errorBody['message'];
        }
        _showSnackBar(errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('❌ حدث خطأ في الاتصال لحذف المستخدم: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Toggle user active status (Admin only)
  Future<void> _toggleUserActiveStatus(int userIdToUpdate, bool currentStatus) async {
    if (_authToken == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/users/$userIdToUpdate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({'active': !currentStatus}),
      );

      if (response.statusCode == 200) {
        _showSnackBar('✅ تم تحديث حالة المستخدم بنجاح!', Colors.green.shade400);
        _fetchAllUsers(); // Refresh the user list
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل تحديث حالة المستخدم: ${response.statusCode}';
        if (errorBody['message'] != null) {
          errorMessage += '\n' + errorBody['message'];
        }
        _showSnackBar(errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('❌ حدث خطأ في الاتصال لتحديث حالة المستخدم: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to logout
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      await prefs.clear();
      _navigateToLoginPage();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('✅ تم تسجيل الخروج بنجاح!', Colors.green.shade400);
      } else {
        _showSnackBar('❌ فشل تسجيل الخروج من الخادم، ولكن تم مسح بياناتك المحلية.', Colors.orange.shade400);
      }
    } catch (e) {
      _showSnackBar('❌ خطأ في الاتصال أثناء تسجيل الخروج: $e. تم مسح بياناتك المحلية.', Colors.red.shade400);
    } finally {
      await prefs.clear();
      _navigateToLoginPage();
    }
  }

  void _navigateToLoginPage() {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.cairo(color: Colors.white)),
          backgroundColor: color,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "لوحة التحكم",
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isLoading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : const Icon(Icons.logout, color: Colors.white),
            onPressed: _isLoading ? null : _logout,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section and user info
                      _buildWelcomeSection(),
                      const SizedBox(height: 30),

                      // Content based on role
                      if (_userRoles.contains('admin'))
                        _buildAdminDashboard()
                      else if (_userRoles.contains('specialist'))
                        _buildSpecialistDashboard()
                      else if (_userRoles.contains('user'))
                        _buildUserDashboard()
                      else
                        _buildDefaultDashboard(), // For users without a specific role

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Welcome section and user info
  Widget _buildWelcomeSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحباً بك، $_userName!",
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "بريدك الإلكتروني: $_userEmail",
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "دورك: ${_userRoles.isNotEmpty ? _userRoles.join(', ') : 'لا يوجد دور'}",
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.teal.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Regular user dashboard
  Widget _buildUserDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ملخصك الشخصي",
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
        ),
        const SizedBox(height: 15),
        _buildDashboardCard(
          title: "الصفحة الرئيسية",
          description: "انتقل إلى الواجهة الرئيسية للتطبيق.",
          icon: Icons.home,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeePage()));
          },
        ),
        _buildDashboardCard(
          title: "رسائل تحفيزية",
          description: "احصل على جرعتك اليومية من الإلهام والطاقة الإيجابية.",
          icon: Icons.lightbulb,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MotivationalMessagesPage()));
          },
        ),
        _buildDashboardCard(
          title: "الاستبيانات",
          description: "راجع إجاباتك السابقة واعرف مستوى تقدمك.",
          icon: Icons.assignment,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionnairePage()));
          },
        ),
        _buildDashboardCard(
          title: "ملاحظاتك اليومية",
          description: "سجل مشاعرك وأفكارك اليومية لمتابعة حالتك النفسية.",
          icon: Icons.notes,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyNotesPage()));
          },
        ),
        _buildDashboardCard(
          title: "نظامك الغذائي وعاداتك",
          description: "تتبع عاداتك الغذائية والسلوكية لتحسين نمط حياتك.",
          icon: Icons.food_bank,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DietAndHabitPage()));
          },
        ),
        _buildDashboardCard(
          title: "الموارد التعليمية",
          description: "استكشف المقالات والفيديوهات التي تدعم صحتك النفسية.",
          icon: Icons.school,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EducationalResourcesPage()));
          },
        ),
        _buildDashboardCard(
          title: "الفوبيا",
          description: "تعرف على الفوبيا وسجل تقدمك في التغلب عليها.",
          icon: Icons.personal_injury,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PhobiaPage()));
          },
        ),
        const SizedBox(height: 20),
        Text(
          "اقتراحات لك:",
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.teal.shade700,
          ),
        ),
        const SizedBox(height: 10),
        _buildSuggestionCard(
          'هل تشعر بالتوتر؟',
          'جرب تمارين التنفس العميق لتحسين حالتك النفسية.',
          Icons.self_improvement,
        ),
        _buildSuggestionCard(
          'لتغذية أفضل',
          'تناول المزيد من الخضروات الورقية الخضراء الغنية بالمغنيسيوم.',
          Icons.local_florist,
        ),
      ],
    );
  }

  // Therapist/Specialist dashboard (example)
  Widget _buildSpecialistDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ملخص المعالج",
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade800,
          ),
        ),
        const SizedBox(height: 15),
        _buildDashboardCard(
          title: "الصفحة الرئيسية",
          description: "انتقل إلى الواجهة الرئيسية للتطبيق.",
          icon: Icons.home,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeePage()));
          },
        ),
        _buildDashboardCard(
          title: "إدارة المستخدمين",
          description: "عرض وتعديل ملفات المستخدمين المخصصين لك.",
          icon: Icons.people_alt,
          onTap: () {
            _showSnackBar('صفحة إدارة المستخدمين قيد الإنشاء.', Colors.blue);
          },
        ),
        _buildDashboardCard(
          title: "تحليل الاستبيانات",
          description: "عرض إحصائيات مجمعة لإجابات الاستبيانات للمستخدمين.",
          icon: Icons.analytics,
          onTap: () {
            _showSnackBar('صفحة تحليل الاستبيانات قيد الإنشاء.', Colors.blue);
          },
        ),
        _buildDashboardCard(
          title: "إدارة الموارد التعليمية",
          description: "إضافة أو تعديل الموارد التعليمية المتاحة للمستخدمين.",
          icon: Icons.library_books,
          onTap: () {
            _showSnackBar('صفحة إدارة الموارد قيد الإنشاء.', Colors.blue);
          },
        ),
      ],
    );
  }

  // Admin dashboard (example)
  Widget _buildAdminDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "لوحة تحكم المدير",
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange.shade800,
          ),
        ),
        const SizedBox(height: 15),
        _buildDashboardCard(
          title: "الصفحة الرئيسية",
          description: "انتقل إلى الواجهة الرئيسية للتطبيق.",
          icon: Icons.home,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeePage()));
          },
        ),
        _buildDashboardCard(
          title: "إدارة المستخدمين والأدوار",
          description: "إدارة جميع حسابات المستخدمين وتعيين أدوارهم.",
          icon: Icons.manage_accounts,
          onTap: () {
            // Display User Management section
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Allow full height for scrolling
              builder: (context) {
                return DraggableScrollableSheet(
                  expand: false, // Don't expand to full screen by default
                  initialChildSize: 0.8, // Initial size
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return _buildUserManagementPanel(scrollController);
                  },
                );
              },
            );
          },
        ),
        _buildDashboardCard(
          title: "إحصائيات النظام",
          description: "مراقبة الأداء العام للتطبيق وعدد الإدخالات.",
          icon: Icons.bar_chart,
          onTap: () {
            _showSnackBar('صفحة الإحصائيات قيد الإنشاء.', Colors.blue);
          },
        ),
        _buildDashboardCard(
          title: "إدارة النصائح والموارد",
          description: "التحكم الكامل بجميع النصائح والموارد التعليمية.",
          icon: Icons.dashboard,
          onTap: () {
            _showSnackBar('صفحة إدارة النصائح قيد الإنشاء.', Colors.blue);
          },
        ),
      ],
    );
  }

  // User Management Panel for Admin
  Widget _buildUserManagementPanel(ScrollController scrollController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "إدارة المستخدمين",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          _isFetchingAllUsers
              ? const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF00796B))))
              : _allUsers.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'لا يوجد مستخدمون حالياً.',
                          style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _allUsers.length,
                        itemBuilder: (context, index) {
                          final user = _allUsers[index];
                          // Skip displaying the current admin user in the list for management
                          // Use _prefs!.getInt to access user_id from SharedPreferences
                          if (_prefs != null && user.id == _prefs!.getInt('user_id')) { // **تم التصحيح هنا: إضافة فحص null لـ _prefs**
                              return const SizedBox.shrink(); // Hide current admin from the list
                          }
                          return _buildUserListItem(user);
                        },
                      ),
                    ),
        ],
      ),
    );
  }


  // User list item for Admin Dashboard
  Widget _buildUserListItem(AppUser user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
            Text(
              user.email,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "الأدوار: ${user.roles.isNotEmpty ? user.roles.join(', ') : 'لا يوجد دور'}",
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.teal.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _confirmToggleActiveStatus(user.id, user.active, user.name),
                  icon: Icon(user.active ? Icons.toggle_on : Icons.toggle_off, color: Colors.white),
                  label: Text(user.active ? "تعطيل" : "تفعيل", style: GoogleFonts.cairo()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user.active ? Colors.orange.shade700 : Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _confirmDeleteUser(user.id, user.name),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text("حذف", style: GoogleFonts.cairo()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Confirm delete user dialog
  void _confirmDeleteUser(int userId, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الحذف", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Text("هل أنت متأكد أنك تريد حذف المستخدم '$userName'؟", style: GoogleFonts.cairo()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey.shade700)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser(userId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("حذف", style: GoogleFonts.cairo(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Confirm toggle active status dialog
  void _confirmToggleActiveStatus(int userId, bool currentStatus, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد تغيير الحالة", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Text(
            "هل أنت متأكد أنك تريد ${currentStatus ? 'تعطيل' : 'تفعيل'} المستخدم '$userName'؟",
            style: GoogleFonts.cairo(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey.shade700)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _toggleUserActiveStatus(userId, currentStatus);
              },
              style: ElevatedButton.styleFrom(backgroundColor: currentStatus ? Colors.orange : Colors.green),
              child: Text(currentStatus ? "تعطيل" : "تفعيل", style: GoogleFonts.cairo(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // General dashboard card widget
  Widget _buildDashboardCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.teal.shade600),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Suggestion card widget (for regular user)
  Widget _buildSuggestionCard(
      String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal.shade50.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.teal.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **New method: _buildDefaultDashboard() for users without a specific role**
  Widget _buildDefaultDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "لوحة معلومات عامة",
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.amber.shade50.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "عذراً، يبدو أن دورك لم يتم تعيينه بعد.",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "يرجى التواصل مع المسؤول لتعيين دور مناسب لك في التطبيق.",
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildDashboardCard(
          title: "الصفحة الرئيسية",
          description: "انتقل إلى الواجهة الرئيسية للتطبيق.",
          icon: Icons.home,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeePage()));
          },
        ),
        _buildDashboardCard(
          title: "تسجيل الخروج",
          description: "يمكنك تسجيل الخروج والعودة إلى شاشة تسجيل الدخول.",
          icon: Icons.logout,
          onTap: _logout,
        ),
      ],
    );
  }
}
