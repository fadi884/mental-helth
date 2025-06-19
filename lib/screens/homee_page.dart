import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart'; // تأكد من استيراد Google Fonts إذا كنت تستخدمها
import 'home.dart'; // تأكد أن هذا المسار صحيح لشاشة تسجيل الدخول
import 'relax_page.dart';
import 'sport_page.dart';
import 'breathing_page.dart';
import 'insomnia_page.dart';
import 'community_page.dart';
import 'voice_therapy_page.dart';
import 'daily_notes_page.dart';
import 'diet_and_habit_page.dart';
import 'educational_resources_page.dart';
import 'mood_tracker_journal_page.dart';
import 'settings_page.dart';
import 'questionnaire_page.dart';
import 'phobia_page.dart'; // استيراد واجهة الفوبيا

class HomeePage extends StatelessWidget {
  const HomeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "الرئيسية",
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == "account") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'صفحة الحساب قيد الإنشاء!',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                );
              } else if (value == "logout") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "account",
                child: Text(
                  "الحساب",
                  style: GoogleFonts.cairo(),
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Text(
                  "تسجيل الخروج",
                  style: GoogleFonts.cairo(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "أهلاً بك!",
                    style: GoogleFonts.cairo(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00796B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "استكشف ميزات التطبيق ودعنا نساعدك في رحلتك نحو الاسترخاء واللياقة.",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Relaxation Card
                  _buildCard(
                    context,
                    'assets/relax.png',
                    "رحلة الاسترخاء",
                    "اضغط هنا لتجربة جلسات التأمل والهدوء.",
                    RelaxScreen(), // تم إزالة 'const' لأن RelaxScreen هو StatefulWidget
                  ),

                  const SizedBox(height: 20),

                  // Sports Card
                  _buildCard(
                    context,
                    'assets/images/sport.png',
                    "ابدأ تمرينك",
                    "اضغط هنا للانتقال إلى صفحة تمارين اللياقة.",
                    const SportPage(),
                  ),

                  const SizedBox(height: 20),

                  // Breathing Exercises Card
                  _buildCard(
                    context,
                    'assets/images/breathing.png',
                    "تمارين التنفس",
                    "اضغط هنا لتجربة تقنيات التنفس العميق للاسترخاء.",
                    const BreathingPage(),
                  ),

                  const SizedBox(height: 20),

                  // Insomnia Tips Card
                  _buildCard(
                    context,
                    'assets/images/insomnia.png',
                    "نصائح للتغلب على الأرق",
                    "اضغط هنا للحصول على إرشادات تساعدك على النوم بشكل أفضل.",
                    const InsomniaPage(),
                  ),

                  const SizedBox(height: 20),

                  // Community Interaction Card
                  _buildCard(
                    context,
                    'assets/images/community.png',
                    "انضم إلى المجتمع",
                    "اضغط هنا للتواصل مع الآخرين والاستفادة من تجاربهم.",
                    const CommunityPage(),
                  ),
                  
                  const SizedBox(height: 20),

                  // Voice Therapy Card
                  _buildCard(
                    context,
                    'assets/images/voice.png',
                    "تفريغ الطاقة الصوتية",
                    "اضغط هنا للتحدث والتعبير عن مشاعرك بحرية.",
                    const VoiceTherapyPage(),
                  ),

                  const SizedBox(height: 20),

                  // Daily Notes Card - **مسار الصورة تم تعديله هنا**
                  _buildCard(
                    context,
                    'assets/images/nots.png', // **تم تغيير هذا المسار بناءً على مدخلاتك**
                    "ملاحظاتك اليومية",
                    "سجل مشاعرك وأفكارك اليومية لتتبع تقدمك.",
                    const DailyNotesPage(),
                  ),

                  const SizedBox(height: 20),

                  // Diet and Habit Card
                  _buildCard(
                    context,
                    'assets/images/diet.png',
                    "نظامك الغذائي وعاداتك",
                    "اكتشف كيف يمكن للعادات الغذائية الصحية أن تحسن حالتك النفسية.",
                    const DietAndHabitPage(),
                  ),

                  const SizedBox(height: 20),

                  // Educational Resources Card
                  _buildCard(
                    context,
                    'assets/images/educational.png',
                    "الموارد التعليمية",
                    "اكتشف مقالات وفيديوهات تساعدك على فهم الصحة النفسية.",
                    const EducationalResourcesPage(),
                  ),

                  const SizedBox(height: 20),

                  // Mood Tracker and Journal Card
                  _buildCard(
                    context,
                    'assets/images/mood_tracker.png', // مسار الصورة الافتراضي
                    "تتبع حالتك ومذكراتك",
                    "سجل مزاجك وأفكارك اليومية لتفهم نفسك بشكل أفضل.",
                    const MoodTrackerJournalPage(),
                  ),

                  const SizedBox(height: 20),
                  
                  // Phobia Card
                  _buildCard(
                    context,
                    'assets/images/phobia.png', // مسار الصورة الجديدة
                    "فهم الفوبيا والتعامل معها",
                    "تعرف على أنواع الفوبيا الشائعة وكيفية التغلب عليها.",
                    const PhobiaPage(),
                  ),

                  const SizedBox(height: 20), // مسافة إضافية في الأسفل
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF26C6DA),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // أنت بالفعل في الرئيسية
          } else if (index == 1) { // مؤشر الاستبيان
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuestionnairePage()),
            );
          } else if (index == 2) { // مؤشر الإعدادات
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "استبيان",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "الإعدادات",
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String imagePath,
    String title,
    String description,
    Widget destination,
  ) {
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
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
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
                    // معالج الأخطاء في حالة عدم العثور على الصورة
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.mood, size: 80, color: Colors.grey.shade500),
                        alignment: Alignment.center,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00796B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
