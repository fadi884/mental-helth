import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts

// تأكد من المسار الصحيح لصفحة المؤقت
import '../screens/breathing_timer_page.dart';

// هذا هو الـ Widget الخاص بواجهة تمارين التنفس
class BreathingPage extends StatelessWidget {
  // **إضافة const constructor هنا لحل مشكلة const في الصفحات الأخرى**
  const BreathingPage({Key? key}) : super(key: key);

  // قائمة بتمارين التنفس (يمكن أن تكون const إذا كانت جميع عناصرها ثابتة)
  final List<Map<String, dynamic>> exercises = const [
    {
      'name': 'تنفس الصندوق (Box Breathing)',
      'duration_seconds': 240, // 4 دقائق (4 ثواني لكل مرحلة)
      'instructions':
          'استنشق ببطء لمدة 4 ثواني، احبس أنفاسك لمدة 4 ثواني، ازفر ببطء لمدة 4 ثواني، ثم ابقَ ورئتيك فارغتين لمدة 4 ثواني. كرر.',
      'benefits': 'يقلل التوتر، يحسن التركيز، ويهدئ الجهاز العصبي.',
      'icon': Icons.crop_square, // يمثل الصندوق
    },
    {
      'name': 'تنفس 4-7-8',
      'duration_seconds': 240, // 4 دقائق
      'instructions':
          'استنشق من الأنف لمدة 4 ثواني، احبس أنفاسك لمدة 7 ثواني، ازفر من الفم لمدة 8 ثواني. كرر.',
      'benefits': 'يساعد على النوم، يقلل القلق، ويهدئ الجسم.',
      'icon': Icons.hourglass_empty, // يمثل الوقت
    },
    {
      'name': 'التنفس العميق من الحجاب الحاجز',
      'duration_seconds': 300, // 5 دقائق
      'instructions':
          'ضع يدًا على صدرك والأخرى على بطنك. استنشق بعمق بحيث ترتفع يدك على بطنك أكثر من يدك على صدرك. ازفر ببطء.',
      'benefits':
          'يزيد من كمية الأكسجين، يقلل من معدل ضربات القلب، ويحسن الهضم.',
      'icon': Icons.healing, // يمثل الشفاء والاسترخاء
    },
    {
      'name': 'التنفس المتبادل عن طريق الأنف (Nadi Shodhana)',
      'duration_seconds': 300, // 5 دقائق
      'instructions':
          'أغلق فتحة الأنف اليمنى بإبهامك، استنشق من اليسرى. أغلق اليسرى بالبنصر، ازفر من اليمنى. استنشق من اليمنى، ثم ازفر من اليسرى. كرر.',
      'benefits':
          'يوازن بين نصفي الدماغ، يقلل التوتر، ويحسن وظائف الجهاز التنفسي.',
      'icon':
          Icons
              .swap_horiz, // يمثل تبادل المسارات (أيقونة بديلة لـ airline_stops)
    },
    {
      'name': 'تمرين التنفس القوي (Bhastrika)',
      'duration_seconds': 180, // 3 دقائق
      'benefits': 'ينشط الجسم، يزيد الطاقة، ويساعد على التخلص من السموم.',
      'instructions':
          'خذ أنفاسًا قوية وسريعة من الأنف، مع التركيز على الزفير. يجب أن يتحرك بطنك بقوة. ابدأ ببطء وزد السرعة تدريجياً.',
      'icon': Icons.whatshot, // يمثل القوة والحرارة
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // جعل جسم التطبيق يمتد خلف شريط التطبيق
      appBar: AppBar(
        title: Text(
          "تمارين التنفس", // عنوان باللغة العربية
          style: GoogleFonts.cairo(
            // استخدام GoogleFonts
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          // إضافة تدرج لوني لشريط التطبيق
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // أيقونة ثابتة
          onPressed: () {
            Navigator.pop(context); // العودة للخلف
          },
        ),
      ),
      body: Container(
        // استخدام Container مع تدرج لوني للخلفية
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0), // زيادة الـ padding
                child: Text(
                  "تحكم في تنفسك وحسّن صحتك.", // نص باللغة العربية
                  style: GoogleFonts.cairo(
                    // استخدام GoogleFonts
                    fontSize: 18, // حجم أكبر للنص التوجيهي
                    color: Colors.blueGrey.shade800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ), // padding للقائمة
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return _buildExerciseListItem(
                      context: context,
                      name: exercise['name'] as String,
                      formattedDuration: _formatDuration(
                        exercise['duration_seconds'] as int,
                      ),
                      instructions: exercise['instructions'] as String,
                      benefits: exercise['benefits'] as String,
                      icon: exercise['icon'] as IconData,
                      durationSeconds: exercise['duration_seconds'] as int,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لتنسيق المدة من الثواني إلى نص (مثلاً: "30 ثانية", "1 دقيقة", "5 دقائق")
  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds ثانية';
    } else {
      int minutes = seconds ~/ 60;
      return '$minutes دقيقة';
    }
  }

  // دالة مساعدة لبناء عنصر قائمة كل تمرين
  Widget _buildExerciseListItem({
    required BuildContext context,
    required String name,
    required String formattedDuration,
    required String instructions,
    required String benefits,
    required IconData icon,
    required int durationSeconds,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 8.0,
      ), // هوامش للبطاقة
      color: Colors.white.withOpacity(0.95), // بطاقة بيضاء بشفافية طفيفة
      elevation: 6, // زيادة الظل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ), // حواف مستديرة
      child: Padding(
        padding: const EdgeInsets.all(16.0), // padding داخلي
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: const Color(0xFF4CAF50),
                ), // أيقونة أكبر بلون أخضر متناسق
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.cairo(
                      // استخدام GoogleFonts
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
                Text(
                  formattedDuration, // عرض المدة المنسقة
                  style: GoogleFonts.cairo(
                    // استخدام GoogleFonts
                    fontSize: 16,
                    color: Colors.green.shade600, // لون المدة متناسق مع الأخضر
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'الفوائد: $benefits', // ترجمة
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.blueGrey.shade700,
              ), // استخدام GoogleFonts
            ),
            const SizedBox(height: 5),
            Text(
              'التعليمات: $instructions', // ترجمة
              style: GoogleFonts.cairo(
                // استخدام GoogleFonts
                fontSize: 14,
                color: Colors.blueGrey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // عند النقر على "ابدأ التمرين"، انتقل إلى صفحة المؤقت
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BreathingTimerPage(
                            // لا تستخدم const هنا إذا BreathingTimerPage ليست const
                            exerciseName: name,
                            durationInSeconds: durationSeconds,
                          ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ), // أيقونة ثابتة
                label: Text(
                  'ابدأ التمرين', // نص الزر بالعربية
                  style: GoogleFonts.cairo(
                    // استخدام GoogleFonts
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50), // لون أخضر جذاب
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ), // ثابتة
                  elevation: 5, // ظل
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
