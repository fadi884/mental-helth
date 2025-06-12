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
import 'diet_and_habit_page.dart'; // **استيراد الواجهة الجديدة هنا**

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

                  // Daily Notes Card
                  _buildCard(
                    context,
                    'assets/images/notes.png',
                    "ملاحظاتك اليومية",
                    "سجل مشاعرك وأفكارك اليومية لتتبع تقدمك.",
                    const DailyNotesPage(),
                  ),

                  const SizedBox(height: 20),

                  // **البطاقة الجديدة: النظام الغذائي والعادات**
                  _buildCard(
                    context,
                    'assets/images/diet.png', // مسار الصورة الجديدة
                    "نظامك الغذائي وعاداتك",
                    "اكتشف كيف يمكن للعادات الغذائية الصحية أن تحسن حالتك النفسية.",
                    const DietAndHabitPage(), // الواجهة الجديدة
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
          } else if (index == 1) {
            // TODO: Navigate to Survey page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'صفحة الاستبيان قيد الإنشاء!',
                  style: GoogleFonts.cairo(),
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "استبيان",
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
