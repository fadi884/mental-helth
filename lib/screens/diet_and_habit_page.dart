import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DietAndHabitPage extends StatelessWidget {
  const DietAndHabitPage({Key? key}) : super(key: key);

  // قائمة بالأنظمة الغذائية المقترحة (بيانات مدمجة حالياً)
  final List<Map<String, dynamic>> dietaryPlans = const [
    {
      'name': 'النظام الغذائي المتوسطي',
      'description':
          'يركز على الأطعمة النباتية مثل الفواكه والخضروات والحبوب الكاملة والبقوليات والمكسرات، مع زيت الزيتون كمصدر رئيسي للدهون الصحية. يتضمن أيضاً الأسماك والدواجن باعتدال ومنتجات الألبان بكميات قليلة.',
      'benefits':
          'يدعم صحة القلب، يقلل الالتهابات، ويحسن المزاج والوظائف الإدراكية.',
      'sample_meals': [
        'الإفطار: زبادي يوناني مع فواكه ومكسرات.',
        'الغداء: سلطة الكينوا مع الخضروات المشوية والحمص.',
        'العشاء: سمك السلمون مع الأرز البني والخضروات المطبوخة بالبخار.',
      ],
      'icon': Icons.local_dining, // أيقونة لمائدة الطعام
    },
    {
      'name': 'نظام غذائي متوازن لزيادة الطاقة',
      'description':
          'يركز على الكربوهيدرات المعقدة لثبات مستويات الطاقة، والبروتينات الخالية من الدهون لإصلاح العضلات، والدهون الصحية لوظائف الدماغ. يتضمن وجبات خفيفة منتظمة لمنع انخفاض السكر في الدم.',
      'benefits': 'يزيد مستويات الطاقة، يحسن التركيز، ويقلل من التعب.',
      'sample_meals': [
        'الإفطار: شوفان بالحليب مع بذور الشيا والفواكه.',
        'الغداء: صدر دجاج مشوي مع البطاطا الحلوة وسلطة خضراء.',
        'العشاء: عدس مع الأرز البني وسلطة خضروات طازجة.',
      ],
      'icon': Icons.flash_on, // أيقونة للطاقة
    },
    {
      'name': 'نظام غذائي لدعم الصحة النفسية',
      'description':
          'يركز على الأطعمة الغنية بالأوميغا 3 (الأسماك الدهنية)، البروبيوتيك (الزبادي، الكيمتشي)، الفيتامينات والمعادن (الخضروات الورقية، المكسرات)، والحد من السكريات المضافة والأطعمة المصنعة.',
      'benefits': 'يدعم صحة الدماغ، يقلل القلق والاكتئاب، ويحسن النوم.',
      'sample_meals': [
        'الإفطار: بيض مخفوق مع سبانخ وأفوكادو.',
        'الغداء: سلطة التونة (أو سمك الماكريل) مع خضروات متنوعة.',
        'العشاء: حساء الخضار الغني مع قطعة خبز القمح الكامل.',
      ],
      'icon': Icons.sentiment_satisfied_alt, // أيقونة للمزاج الجيد
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "نظامك الغذائي وعاداتك",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
            ], // تدرج أزرق سماوي ناعم
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "كيف يؤثر طعامك وعاداتك على صحتك النفسية؟",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "تغذية سليمة لحياة أفضل",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "تلعب الأطعمة التي نتناولها دورًا حاسمًا في صحتنا الجسدية والعقلية. يمكن لنظام غذائي متوازن أن يدعم وظائف الدماغ، ويحسن المزاج، ويقلل من خطر الإصابة باضطرابات نفسية.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "عادات صحية ليوم مليء بالإيجابية",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "لا يقتصر الأمر على الطعام فقط؛ فالعادات اليومية مثل ممارسة الرياضة، الحصول على قسط كافٍ من النوم، وتقليل التوتر، جميعها تساهم في تحسين حالتك النفسية والعامة.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),

                // **القسم الجديد: أنظمة غذائية مقترحة**
                Text(
                  "أنظمة غذائية مقترحة:",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // استخدام Column بدلاً من ListView.builder لعدد قليل من العناصر
                Column(
                  children:
                      dietaryPlans.map((plan) {
                        return _buildDietPlanCard(
                          context,
                          plan['name'] as String,
                          plan['description'] as String,
                          plan['benefits'] as String,
                          plan['sample_meals'] as List<String>,
                          plan['icon'] as IconData,
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 60,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "محتوى تفاعلي قادم قريباً!",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "نعمل على إضافة ميزات مثل تتبع العادات، وصفات صحية، وخطط غذائية مخصصة.",
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء بطاقة النظام الغذائي
  Widget _buildDietPlanCard(
    BuildContext context,
    String name,
    String description,
    String benefits,
    List<String> sampleMeals,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'الوصف: $description',
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'الفوائد: $benefits',
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.green.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'أمثلة على الوجبات:',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  sampleMeals.map((meal) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
                      child: Text(
                        '• $meal',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
