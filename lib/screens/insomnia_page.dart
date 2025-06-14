import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts

// تأكد من المسار الصحيح لصفحة المؤقت
import '../screens/exercise_timer_page.dart';

// هذا هو الـ Widget الخاص بواجهة نصائح الأرق
class InsomniaPage extends StatelessWidget {
  // **إضافة const constructor هنا لحل مشكلة const في الصفحات الأخرى**
  const InsomniaPage({Key? key}) : super(key: key);

  // قائمة بتقنيات مساعدة النوم (يمكن أن تكون const إذا كانت جميع عناصرها ثابتة)
  final List<Map<String, dynamic>> sleepAidTechniques = const [
    {
      'name': 'الاسترخاء العضلي التدريجي',
      'duration_seconds': 480, // 8 دقائق
      'instructions': 'ابدأ بشد مجموعة عضلية واحدة (مثل أصابع القدم) لمدة 5 ثوانٍ ثم أرخها تمامًا لمدة 30 ثانية. انتقل تدريجياً إلى مجموعات العضلات الأخرى في جسمك.',
      'benefits': 'يقلل التوتر الجسدي، يعزز الاسترخاء العميق، ويساعد على النوم.',
      'icon': Icons.self_improvement, // يمثل الاسترخاء/التحسين الذاتي
    },
    {
      'name': 'تأمل اليقظة قبل النوم',
      'duration_seconds': 600, // 10 دقائق
      'instructions': 'اجلس أو استلقِ براحة. ركز على أنفاسك وإحساس جسمك. إذا شرد ذهنك، أعد تركيزك بلطف إلى اللحظة الحالية.',
      'benefits': 'يهدئ العقل المزدحم، يقلل القلق، ويحسن جودة النوم.',
      'icon': Icons.spa, // يمثل اليقظة الذهنية/الاسترخاء
    },
    {
      'name': 'تنفس البطن الهادئ',
      'duration_seconds': 300, // 5 دقائق
      'instructions': 'استلقِ ويد على بطنك. استنشق ببطء من أنفك، ودع بطنك يرتفع. ازفر ببطء من فمك، ودع بطنك ينخفض. ركز على الإيقاع الهادئ.',
      'benefits': 'ينشط الجهاز العصبي السمبثاوي، يقلل معدل ضربات القلب، ويهيئ الجسم للنوم.',
      'icon': Icons.bedtime, // يمثل النوم/الليل
    },
    {
      'name': 'روتين التهدئة قبل النوم',
      'duration_seconds': 900, // 15 دقائق (مرن)
      'instructions': 'خصص 15 دقيقة قبل النوم لأنشطة هادئة مثل قراءة كتاب، أخذ حمام دافئ، أو الاستماع إلى موسيقى هادئة. تجنب الشاشات.',
      'benefits': 'يرسل إشارات لجسمك بأن وقت النوم قد حان، ويحسن الاسترخاء.',
      'icon': Icons.menu_book, // يمثل القراءة/الروتين
    },
    {
      'name': 'قائمة الامتنان القصيرة',
      'duration_seconds': 180, // 3 دقائق
      'instructions': 'قبل النوم، فكر في 3-5 أشياء تشعر بالامتنان لها خلال اليوم. اكتبها أو فكر فيها بصمت.',
      'benefits': 'يحول التركيز من القلق إلى الإيجابية، ويهدئ العقل للنوم.',
      'icon': Icons.favorite_border, // يمثل الامتنان/القلب
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // جعل جسم التطبيق يمتد خلف شريط التطبيق
      appBar: AppBar(
        title: Text(
          "نصائح للتغلب على الأرق", // عنوان باللغة العربية
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
                  "تقنيات مهدئة لمساعدتك على النوم بشكل أفضل.", // نص باللغة العربية
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
                  itemCount: sleepAidTechniques.length,
                  itemBuilder: (context, index) {
                    final technique = sleepAidTechniques[index];
                    return _buildTechniqueListItem(
                      context: context,
                      name: technique['name'] as String,
                      formattedDuration: _formatDuration(technique['duration_seconds'] as int),
                      instructions: technique['instructions'] as String,
                      benefits: technique['benefits'] as String,
                      icon: technique['icon'] as IconData,
                      durationSeconds: technique['duration_seconds'] as int,
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

  // دالة مساعدة لبناء عنصر قائمة كل تقنية
  Widget _buildTechniqueListItem({
    required BuildContext context,
    required String name,
    required String formattedDuration,
    required String instructions,
    required String benefits,
    required IconData icon,
    required int durationSeconds,
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
                Icon(icon, size: 35, color: const Color(0xFF42A5F5)), // أيقونة أكبر بلون أزرق مهدئ
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
                    color: Colors.blue.shade600, // لون المدة متناسق
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
                  // عند النقر على "ابدأ التقنية"، انتقل إلى صفحة المؤقت
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
                  'ابدأ التقنية', // نص الزر بالعربية
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
