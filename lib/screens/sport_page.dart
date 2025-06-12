import 'dart:math'; // لاستخدام Random
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts

// تأكد من أن المسارات التالية صحيحة:
import '../screens/energy_boost_exercise_page.dart';
import '../screens/focus_improvement_exercise_page.dart';
import '../screens/anxiety_relief_exercise_page.dart';
import '../screens/distress_relief_exercise_page.dart'; // استيراد الواجهة الجديدة لـ "عندما تشعر بالضيق"

class SportPage extends StatefulWidget {
  // إضافة const constructor هنا لتسهيل الاستدعاء من HomeePage
  const SportPage({Key? key}) : super(key: key);

  @override
  _SportPageState createState() => _SportPageState();
}

class _SportPageState extends State<SportPage> {
  // قائمة لفئات التمارين مع تحديث النصوص والأيقونات
  final List<Map<String, dynamic>> exerciseCategories = [
    {
      'title': 'لتعزيز الطاقة',
      'subtitle': 'حركات سريعة لتنشيط الجسم والمزاج.',
      'icon': Icons.directions_run, // أيقونة أكثر ملاءمة للرياضة
      'color': Colors.orange.shade300,
      'page': const EnergyBoostExercisePage(), // افتراض أن الصفحة لديها const constructor
    },
    {
      'title': 'لتخفيف القلق',
      'subtitle': 'يوجا وتمارين تمدد لتهدئة العقل.',
      'icon': Icons.self_improvement,
      'color': Colors.blue.shade300,
      'page': const AnxietyReliefExercisePage(), // افتراض أن الصفحة لديها const constructor
    },
    {
      'title': 'لتحسين التركيز',
      'subtitle': 'تمارين التوازن والوعي الجسدي.',
      'icon': Icons.center_focus_strong,
      'color': Colors.purple.shade300,
      'page': const FocusImprovementExercisePage(), // افتراض أن الصفحة لديها const constructor
    },
    {
      'title': 'عندما تشعر بالضيق',
      'subtitle': 'تفريغ الطاقة السلبية بحركات ديناميكية.',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.red.shade300,
      'page': const DistressReliefExercisePage(), // افتراض أن الصفحة لديها const constructor
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // تمديد الجسم خلف الـ AppBar لجمالية التدرج
      appBar: AppBar(
        title: Text(
          "تمارين جسدية لصحة أفضل", // عنوان باللغة العربية
          style: GoogleFonts.cairo( // استخدام GoogleFonts
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container( // إضافة تدرج لوني لشريط التطبيق
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)], // تدرج أزرق فاتح
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // شفافية الخلفية
        elevation: 0, // إزالة الظل
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // أيقونة ثابتة
          onPressed: () {
            Navigator.pop(context); // العودة للخلف
          },
        ),
      ),
      body: Container( // استخدام Container مع تدرج لوني للخلفية
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // تدرج أزرق سماوي ناعم
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // زيادة الـ padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "اختر تمرينًا يناسب شعورك اليوم:", // نص باللغة العربية
                  style: GoogleFonts.cairo( // استخدام GoogleFonts
                    fontSize: 20, // حجم أكبر للنص التوجيهي
                    color: Colors.blueGrey.shade800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30), // زيادة المسافة
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( // جعلها const
                      crossAxisCount: 2,
                      crossAxisSpacing: 18.0, // زيادة المسافة بين العناصر
                      mainAxisSpacing: 18.0, // زيادة المسافة بين الصفوف
                      childAspectRatio: 0.9, // الحفاظ على نسبة العرض إلى الارتفاع
                    ),
                    itemCount: exerciseCategories.length,
                    itemBuilder: (context, index) {
                      final category = exerciseCategories[index];
                      return _buildExerciseCard(
                        context,
                        category['title'] as String,
                        category['subtitle'] as String,
                        category['icon'] as IconData,
                        category['color'] as Color,
                        category['page'] as Widget?, // يتم تمريره كـ Widget?
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء بطاقات التمارين بشكل احترافي
  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget? targetPage, // يمكن أن تكون الصفحة فارغة
  ) {
    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        } else {
          // التحقق من mounted قبل استخدام ScaffoldMessenger
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم اختيار: $title - الصفحة غير متوفرة بعد!',
                  style: GoogleFonts.cairo(), // استخدام GoogleFonts
                ),
                backgroundColor: Colors.orange.shade400,
              ),
            );
          }
        }
      },
      child: Card(
        color: color.withOpacity(0.9), // لون البطاقة بشفافية
        elevation: 10, // زيادة الظل لإعطاء عمق
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // حواف أكثر استدارة
        child: Padding(
          padding: const EdgeInsets.all(18.0), // زيادة الـ padding الداخلي
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 55, color: Colors.white), // حجم أكبر للأيقونة
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo( // استخدام GoogleFonts
                  color: Colors.white,
                  fontSize: 20, // حجم أكبر للعنوان
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo( // استخدام GoogleFonts
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14, // حجم مناسب للعنوان الفرعي
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
