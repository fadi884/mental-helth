import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد جميع الصفحات ذات الصلة
import 'breathing_page.dart'; // لتمارين التنفس
import 'sport_page.dart';     // للنشاط البدني العام
import 'insomnia_page.dart';   // لنصائح النوم
import 'diet_and_habit_page.dart'; // للنظام الغذائي والعادات
import 'community_page.dart'; // للمجتمع والتواصل

class UnderstandingAnxietyPage extends StatelessWidget {
  const UnderstandingAnxietyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "فهم القلق: الأسباب والتعامل", // عنوان الصفحة
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, // حجم أصغر قليلاً للعنوان الطويل
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
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // تدرج أزرق سماوي ناعم
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
                  "ما هو القلق؟",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "القلق هو شعور طبيعي بالخوف أو الانزعاج أو عدم الارتياح. إنه جزء من استجابة الجسم للتوتر، ويمكن أن يكون مفيدًا في بعض المواقف، مثل تنبيهنا للخطر المحتمل.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "ولكن عندما يصبح القلق مفرطًا، مستمرًا، أو غير متناسب مع الموقف، فقد يتحول إلى اضطراب قلق يؤثر على الحياة اليومية.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  "الأسباب المحتملة للقلق:",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                _buildBulletPoint(
                  "العوامل الوراثية: قد يكون هناك استعداد وراثي للإصابة بالقلق.",
                  Colors.green.shade700,
                ),
                _buildBulletPoint(
                  "كيمياء الدماغ: اختلال في المواد الكيميائية مثل السيروتونين والدوبامين.",
                  Colors.green.shade700,
                ),
                _buildBulletPoint(
                  "الضغوط الحياتية: مثل المشاكل المالية، مشاكل العلاقات، أو الإجهاد في العمل.",
                  Colors.green.shade700,
                ),
                _buildBulletPoint(
                  "الصدمات: التجارب المؤلمة في الماضي يمكن أن تساهم في تطور القلق.",
                  Colors.green.shade700,
                ),
                _buildBulletPoint(
                  "الحالات الطبية: بعض الأمراض الجسدية أو الأدوية قد تسبب أعراض القلق.",
                  Colors.green.shade700,
                ),
                const SizedBox(height: 30),

                Text(
                  "استراتيجيات التعامل مع القلق:",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                // ربط البطاقات بالواجهات المناسبة
                _buildCopingStrategy(
                  context, // تمرير الـ context
                  Icons.self_improvement,
                  "تمارين التنفس والاسترخاء",
                  "ممارسة التنفس العميق والبطيء (مثل تنفس البطن) وتقنيات الاسترخاء العضلي التدريجي لتهدئة الجسم والعقل.",
                  Colors.purple.shade700,
                  const BreathingPage(), // وجهة تمارين التنفس
                ),
                _buildCopingStrategy(
                  context, // تمرير الـ context
                  Icons.run_circle,
                  "النشاط البدني المنتظم",
                  "ممارسة الرياضة بانتظام تساعد في تقليل هرمونات التوتر وتحسين المزاج بفضل إطلاق الإندورفينات.",
                  Colors.orange.shade700,
                  const SportPage(), // وجهة صفحة الرياضة
                ),
                _buildCopingStrategy(
                  context, // تمرير الـ context
                  Icons.nights_stay,
                  "النوم الكافي",
                  "الحصول على 7-9 ساعات من النوم الجيد ليلاً ضروري لتنظيم المزاج والقدرة على التعامل مع التوتر.",
                  Colors.indigo.shade700,
                  const InsomniaPage(), // وجهة نصائح الأرق
                ),
                _buildCopingStrategy(
                  context, // تمرير الـ context
                  Icons.clean_hands,
                  "نظام غذائي صحي ومتوازن",
                  "تجنب الكافيين والسكر المفرط، وركز على الأطعمة الغنية بالمغذيات التي تدعم صحة الدماغ.",
                  Colors.green.shade700,
                  const DietAndHabitPage(), // وجهة النظام الغذائي
                ),
                _buildCopingStrategy(
                  context, // تمرير الـ context
                  Icons.chat,
                  "التحدث مع الآخرين",
                  "مشاركة مشاعرك مع صديق موثوق به، فرد من العائلة، أو أخصائي نفسي يمكن أن يوفر الدعم ويساعدك على رؤية الأمور بمنظور مختلف.",
                  Colors.blue.shade700,
                  const CommunityPage(), // وجهة صفحة المجتمع
                ),
                _buildCopingStrategy(
                  context, // تمرير الـ context
                  Icons.psychology,
                  "طلب المساعدة المهنية",
                  "إذا كان القلق يؤثر بشكل كبير على حياتك، فلا تتردد في استشارة طبيب أو معالج نفسي للحصول على التشخيص والعلاج المناسبين.",
                  Colors.red.shade700,
                  null, // لا توجد صفحة محددة حالياً، لذا نمرر null
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء نقاط التعداد
  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء استراتيجية التعامل
  Widget _buildCopingStrategy(
    BuildContext context, // تم إضافة context هنا
    IconData icon,
    String title,
    String description,
    Color color,
    Widget? destination, // تم إضافة الوجهة هنا (يمكن أن تكون null)
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: color),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
            if (destination != null) // عرض الزر فقط إذا كانت هناك وجهة
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => destination),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
                    label: Text(
                      'اذهب إلى المورد',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600, // لون متناسق
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      elevation: 5,
                    ),
                  ),
                ),
              ),
            if (destination == null) // عرض رسالة بدلاً من الزر إذا لم تكن هناك وجهة
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'للحصول على المساعدة المهنية، يرجى استشارة أخصائي.',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
