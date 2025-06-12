import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts

// تأكد من المسار الصحيح لصفحة المؤقت
import '../screens/exercise_timer_page.dart';

// هذا هو الـ Widget الخاص بواجهة تمارين تخفيف القلق
class AnxietyReliefExercisePage extends StatelessWidget {
  // **إضافة const constructor هنا لحل مشكلة const في الصفحات الأخرى**
  const AnxietyReliefExercisePage({Key? key}) : super(key: key);

  // قائمة بتمارين تخفيف القلق (يمكن أن تكون const إذا كانت جميع عناصرها ثابتة)
  final List<Map<String, dynamic>> exercises = const [
    {
      'name': 'تنفس البطن الهادئ',
      'duration_seconds': 180, // 3 دقائق
      'benefits': 'يهدئ الجهاز العصبي ويقلل التوتر بشكل فوري.',
      'instructions': 'استلقِ أو اجلس بشكل مريح. ضع يدًا على بطنك، وتنفس بعمق بحيث ترتفع يدك.',
      'icon': Icons.self_improvement, // أيقونة مناسبة للتأمل/التحسين الذاتي
    },
    {
      'name': 'تمدد الرقبة والكتفين',
      'duration_seconds': 120, // 2 دقيقة
      'benefits': 'يخفف التوتر المتراكم في الجزء العلوي من الجسم.',
      'instructions': 'أمل رأسك ببطء نحو الكتف، ثم الكتف الآخر. كرر.',
      'icon': Icons.accessibility_new, // أيقونة للتمدد
    },
    {
      'name': 'تأمل اليقظة الصوتية',
      'duration_seconds': 300, // 5 دقائق
      'benefits': 'يعيد تركيز الانتباه بعيدًا عن الأفكار المقلقة.',
      'instructions': 'اجلس في مكان هادئ. ركز على الأصوات من حولك دون الحكم عليها.',
      'icon': Icons.hearing, // أيقونة الاستماع
    },
    {
      'name': 'تمارين تمدد خفيفة لكامل الجسم',
      'duration_seconds': 240, // 4 دقائق
      'benefits': 'يطلق التوتر من العضلات الكبيرة ويعزز الشعور بالراحة.',
      'instructions': 'قم بتمديد ذراعيك وساقيك وجذعك بلطف. استمع إلى جسدك.',
      'icon': Icons.fitness_center, // أيقونة اللياقة البدنية/التمدد
    },
    {
      'name': 'الاسترخاء التدريجي للعضلات',
      'duration_seconds': 360, // 6 دقائق
      'benefits': 'يعلمك كيفية التعرف على التوتر في العضلات وإطلاق سراحه.',
      'instructions': 'شد مجموعة عضلية واحدة ثم أرخها تمامًا. كرر لكل مجموعة عضلية.',
      'icon': Icons.spa, // أيقونة الاسترخاء
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // جعل جسم التطبيق يمتد خلف شريط التطبيق
      appBar: AppBar(
        title: Text(
          "تمارين لتخفيف القلق", // عنوان باللغة العربية
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0), // زيادة الـ padding
                child: Text(
                  "جلسات هادئة للمساعدة على تهدئة العقل والجسم.", // نص باللغة العربية
                  style: GoogleFonts.cairo( // استخدام GoogleFonts
                    fontSize: 18, // حجم أكبر للنص التوجيهي
                    color: Colors.blueGrey.shade800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // padding للقائمة
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return _buildExerciseListItem(
                      context: context,
                      name: exercise['name'] as String,
                      formattedDuration: _formatDuration(exercise['duration_seconds'] as int),
                      benefits: exercise['benefits'] as String,
                      instructions: exercise['instructions'] as String,
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
    required String formattedDuration, // المدة المنسقة للعرض
    required String benefits,
    required String instructions,
    required IconData icon,
    required int durationSeconds, // المدة بالثواني التي ستمرر إلى المؤقت
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // هوامش للبطاقة
      color: Colors.white.withOpacity(0.95), // بطاقة بيضاء بشفافية طفيفة
      elevation: 6, // زيادة الظل
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // حواف مستديرة
      child: Padding(
        padding: const EdgeInsets.all(16.0), // padding داخلي
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 35, color: const Color(0xFF0288D1)), // أيقونة أكبر بلون متناسق
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.cairo( // استخدام GoogleFonts
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
                Text(
                  formattedDuration, // عرض المدة المنسقة
                  style: GoogleFonts.cairo( // استخدام GoogleFonts
                    fontSize: 16,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'الفوائد: $benefits', // ترجمة
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.blueGrey.shade700), // استخدام GoogleFonts
            ),
            const SizedBox(height: 5),
            Text(
              'التعليمات: $instructions', // ترجمة
              style: GoogleFonts.cairo( // استخدام GoogleFonts
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
                      builder: (context) => ExerciseTimerPage( // لا تستخدم const هنا إذا ExerciseTimerPage ليست const
                        exerciseName: name,
                        durationInSeconds: durationSeconds,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white), // أيقونة ثابتة
                label: Text(
                  'ابدأ التمرين', // نص الزر بالعربية
                  style: GoogleFonts.cairo( // استخدام GoogleFonts
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0288D1), // لون أزرق جذاب
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // ثابتة
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
