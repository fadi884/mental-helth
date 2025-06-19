import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkplaceMentalHealthPage extends StatelessWidget {
  const WorkplaceMentalHealthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "الصحة النفسية في مكان العمل",
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
                  "بيئة عمل صحية، عقل سليم",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "تعد صحتك النفسية في مكان العمل أمراً حيوياً لإنتاجيتك ورفاهيتك العامة. إليك بعض النصائح للحفاظ عليها:",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTipCard(
                  Icons.timer,
                  "إدارة الوقت والمهام",
                  "حدد أولوياتك وخذ فترات راحة قصيرة لتجنب الإرهاق.",
                  Colors.blue.shade700,
                ),
                _buildTipCard(
                  Icons.people,
                  "بناء علاقات إيجابية",
                  "تواصل مع زملائك، وقدم الدعم، واطلب المساعدة عند الحاجة.",
                  Colors.green.shade700,
                ),
                _buildTipCard(
                  Icons.self_improvement,
                  "مارس اليقظة الذهنية",
                  "خصص دقائق قليلة خلال اليوم لممارسة تمارين التنفس أو التأمل لتقليل التوتر.",
                  Colors.purple.shade700,
                ),
                _buildTipCard(
                  Icons.work_off,
                  "فصل الحياة العملية عن الشخصية",
                  "حاول ألا تأخذ هموم العمل إلى المنزل، وخصص وقتاً للراحة والهوايات.",
                  Colors.red.shade700,
                ),
                _buildTipCard(
                  Icons.psychology,
                  "لا تتردد في طلب المساعدة",
                  "إذا كنت تشعر بالإرهاق أو التوتر الشديد، تحدث مع مشرفك أو مستشار مختص.",
                  Colors.orange.shade700,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(IconData icon, String title, String description, Color color) {
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
