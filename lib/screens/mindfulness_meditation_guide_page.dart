import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MindfulnessMeditationGuidePage extends StatelessWidget {
  const MindfulnessMeditationGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "أدلة المبتدئين للتأمل",
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
                  "ما هو التأمل اليقظ (Mindfulness Meditation)؟",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "التأمل اليقظ هو ممارسة تركز على البقاء في اللحظة الحالية وملاحظة أفكارك ومشاعرك وأحاسيسك الجسدية دون إصدار أحكام.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "كيف تبدأ؟",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                _buildStep(
                  '1. ابحث عن مكان هادئ: اختر مكاناً خالياً من التشتت.',
                  Icons.vpn_key,
                  Colors.green.shade700,
                ),
                _buildStep(
                  '2. اجلس أو استلقِ براحة: حافظ على وضعية مريحة ومستقيمة.',
                  Icons.chair,
                  Colors.blue.shade700,
                ),
                _buildStep(
                  '3. ركز على أنفاسك: لاحظ دخول وخروج الهواء من جسدك.',
                  Icons.air,
                  Colors.purple.shade700,
                ),
                _buildStep(
                  '4. تقبل الأفكار: عندما تتشتت، أعد انتباهك بلطف إلى أنفاسك.',
                  Icons.psychology,
                  Colors.orange.shade700,
                ),
                _buildStep(
                  '5. ابدأ بفترات قصيرة: 5-10 دقائق يومياً هي بداية رائعة.',
                  Icons.timer,
                  Colors.red.shade700,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.audiotrack, size: 60, color: Colors.teal.shade700),
                      const SizedBox(height: 10),
                      Text(
                        "استمع إلى جلسات التأمل الموجهة",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "يمكنك البحث عن تطبيقات أو تسجيلات صوتية تساعدك في ممارسة التأمل اليقظ.",
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

  Widget _buildStep(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
