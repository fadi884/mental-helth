import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StressManagementTechniquesPage extends StatelessWidget {
  const StressManagementTechniquesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "تقنيات إدارة التوتر والإجهاد",
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                  "أدوات عملية لتهدئة عقلك وجسدك",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "تعد إدارة التوتر مهارة حيوية للحفاظ على الصحة النفسية. إليك بعض التقنيات الفعالة التي يمكنك ممارستها يومياً:",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTechniqueCard(
                  Icons.self_improvement,
                  "التأمل واليقظة الذهنية",
                  "ممارسة التركيز على اللحظة الحالية، وملاحظة الأفكار دون الحكم عليها. يمكن أن يساعد في تقليل ردود الفعل التوترية.",
                  Colors.purple.shade700,
                ),
                _buildTechniqueCard(
                  Icons.run_circle,
                  "النشاط البدني المنتظم",
                  "الرياضة تحرر الإندورفينات التي تعمل كمسكن طبيعي للتوتر وتحسن المزاج.",
                  Colors.orange.shade700,
                ),
                _buildTechniqueCard(
                  Icons.nights_stay,
                  "الحصول على نوم كافٍ",
                  "النوم الجيد ضروري لتجديد الجسم والعقل وقدرتهما على التعامل مع الضغوط.",
                  Colors.indigo.shade700,
                ),
                _buildTechniqueCard(
                  Icons.book,
                  "كتابة اليوميات",
                  "تدوين الأفكار والمشاعر يمكن أن يساعد في معالجتها وتقليل التوتر.",
                  Colors.brown.shade700,
                ),
                _buildTechniqueCard(
                  Icons.person_pin_circle,
                  "الاسترخاء العضلي التدريجي",
                  "شد وإرخاء مجموعات العضلات المختلفة في الجسم لملاحظة الفرق بين التوتر والاسترخاء.",
                  Colors.lightGreen.shade700,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechniqueCard(IconData icon, String title, String description, Color color) {
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
          ],
        ),
      ),
    );
  }
}
