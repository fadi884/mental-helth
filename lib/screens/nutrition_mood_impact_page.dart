import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionMoodImpactPage extends StatelessWidget {
  const NutritionMoodImpactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "تأثير التغذية على المزاج",
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
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
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
                  "العلاقة بين ما تأكله وكيف تشعر",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "تؤثر التغذية بشكل مباشر على وظائف الدماغ وإنتاج الناقلات العصبية التي تنظم المزاج. نظام غذائي صحي يمكن أن يكون حليفاً قوياً لصحتك النفسية.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "أطعمة تعزز المزاج:",
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                _buildFoodItem(
                  'الأحماض الدهنية أوميغا 3 (الأسماك الدهنية، بذور الكتان)',
                  'تدعم وظائف الدماغ وتقلل الالتهاب.',
                  Icons.local_dining,
                ),
                _buildFoodItem(
                  'البروبيوتيك (الزبادي، الكيمتشي)',
                  'يعزز صحة الأمعاء، والتي ترتبط ارتباطاً وثيقاً بالمزاج.',
                  Icons.local_florist,
                ),
                _buildFoodItem(
                  'الحبوب الكاملة (الشوفان، الأرز البني)',
                  'توفر طاقة مستقرة وتساعد على استقرار مستويات السكر في الدم.',
                  Icons.grain,
                ),
                _buildFoodItem(
                  'الفواكه والخضروات الملونة',
                  'غنية بمضادات الأكسدة والفيتامينات الضرورية لصحة الدماغ.',
                  Icons.apple,
                ),
                const SizedBox(height: 30),
                Text(
                  "أطعمة يجب تقليلها:",
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                _buildFoodItem(
                  'السكريات المضافة',
                  'تؤدي إلى تقلبات سريعة في مستويات السكر وتؤثر سلباً على المزاج.',
                  Icons.bakery_dining, // **تم تغيير الأيقونة هنا**
                ),
                _buildFoodItem(
                  'الأطعمة المصنعة',
                  'عادة ما تكون قليلة المغذيات وغنية بالدهون غير الصحية والمواد المضافة.',
                  Icons.fastfood,
                ),
                _buildFoodItem(
                  'الكافيين المفرط',
                  'يمكن أن يزيد من القلق ويؤثر على النوم.',
                  Icons.coffee,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItem(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.orange.shade700),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.blueGrey.shade700,
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
}
