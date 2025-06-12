import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts
import 'package:flutter_application_1/services/api_service.dart'; // تأكد من المسار الصحيح لـ ApiService
import '../screens/homee_page.dart'; // استيراد الصفحة الرئيسية (HomeePage)

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService(); // إنشاء كائن من ApiService

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController anxietyLevelController = TextEditingController();
  final TextEditingController stressLevelController = TextEditingController();
  final TextEditingController symptomsFrequencyController =
      TextEditingController();
  final TextEditingController symptomsSeverityController =
      TextEditingController();
  final TextEditingController physicalSymptomsController =
      TextEditingController();
  final TextEditingController psychologicalSymptomsController =
      TextEditingController();
  final TextEditingController triggersController = TextEditingController();
  final TextEditingController copingStrategyController =
      TextEditingController();
  final TextEditingController dailyLifeImpactController =
      TextEditingController();
  final TextEditingController supportNeedsController = TextEditingController();

  @override
  void dispose() {
    userIdController.dispose();
    dateController.dispose();
    anxietyLevelController.dispose();
    stressLevelController.dispose();
    symptomsFrequencyController.dispose();
    symptomsSeverityController.dispose();
    physicalSymptomsController.dispose();
    psychologicalSymptomsController.dispose();
    triggersController.dispose();
    copingStrategyController.dispose();
    dailyLifeImpactController.dispose();
    supportNeedsController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> questionnaireData = {
        "user_id": userIdController.text.trim(),
        "date": dateController.text.trim(),
        "anxiety_level": int.tryParse(anxietyLevelController.text.trim()) ?? 0,
        "stress_level": int.tryParse(stressLevelController.text.trim()) ?? 0,
        "symptoms_frequency": symptomsFrequencyController.text.trim(),
        "symptoms_severity": symptomsSeverityController.text.trim(),
        "physical_symptoms": physicalSymptomsController.text.trim(),
        "psychological_symptoms": psychologicalSymptomsController.text.trim(),
        "triggers": triggersController.text.trim(),
        "coping_strategy": copingStrategyController.text.trim(),
        "daily_life_impact": dailyLifeImpactController.text.trim(),
        "support_needs": supportNeedsController.text.trim(),
      };

      bool success = await apiService.sendQuestionnaire(questionnaireData);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ تم إرسال الاستبيان بنجاح!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeePage(),
            ), // تأكد من اسم الصفحة هنا
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ حدث خطأ أثناء إرسال الاستبيان!'),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'استبيان الصحة النفسية',
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "الرجاء الإجابة على الأسئلة التالية لمساعدتنا على فهم حالتك النفسية بشكل أفضل.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.blueGrey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildQuestionnaireField(
                    controller: userIdController,
                    label: "معرف المستخدم (User ID)",
                    icon: Icons.person,
                    keyboardType: TextInputType.number,
                  ),
                  _buildQuestionnaireField(
                    controller: dateController,
                    label: "التاريخ",
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(
                        context,
                      ).requestFocus(FocusNode()); // لإخفاء لوحة المفاتيح
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: GoogleFonts.cairoTextTheme(
                                Theme.of(context).textTheme,
                              ),
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF0288D1),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFF0288D1),
                                  textStyle: GoogleFonts.cairo(),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        dateController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                  _buildQuestionnaireField(
                    controller: anxietyLevelController,
                    label: "مستوى القلق (1-10)",
                    icon: Icons.mood_bad,
                    keyboardType: TextInputType.number,
                  ),
                  _buildQuestionnaireField(
                    controller: stressLevelController,
                    label: "مستوى التوتر (1-10)",
                    icon: Icons.sentiment_neutral,
                    keyboardType: TextInputType.number,
                  ),
                  _buildQuestionnaireField(
                    controller: symptomsFrequencyController,
                    label: "تكرار الأعراض",
                    icon: Icons.repeat,
                  ),
                  _buildQuestionnaireField(
                    controller: symptomsSeverityController,
                    label: "شدة الأعراض",
                    icon: Icons.medical_services,
                  ),
                  _buildQuestionnaireField(
                    controller: physicalSymptomsController,
                    label: "الأعراض الجسدية",
                    icon: Icons.healing, // تم التعديل هنا
                  ),
                  _buildQuestionnaireField(
                    controller: psychologicalSymptomsController,
                    label: "الأعراض النفسية",
                    icon: Icons.psychology,
                  ),
                  _buildQuestionnaireField(
                    controller: triggersController,
                    label: "المحفزات",
                    icon: Icons.flash_on,
                  ),
                  _buildQuestionnaireField(
                    controller: copingStrategyController,
                    label: "استراتيجيات التكيف",
                    icon: Icons.lightbulb,
                  ),
                  _buildQuestionnaireField(
                    controller: dailyLifeImpactController,
                    label: "تأثير على الحياة اليومية",
                    icon: Icons.work,
                  ),
                  _buildQuestionnaireField(
                    controller: supportNeedsController,
                    label: "احتياجات الدعم",
                    icon: Icons.handshake,
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: submitForm,
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text(
                        "إرسال الاستبيان",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء حقول الاستبيان بشكل احترافي
  Widget _buildQuestionnaireField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: onTap != null, // جعل الحقل للقراءة فقط إذا كان لديه onTap
        onTap: onTap, // تمرير دالة onTap
        decoration: InputDecoration(
          labelText: label,
          hintText: 'أدخل $label',
          prefixIcon: Icon(icon, color: Colors.blueGrey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueGrey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0288D1), width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          labelStyle: GoogleFonts.cairo(color: Colors.blueGrey.shade800),
          hintStyle: GoogleFonts.cairo(color: Colors.grey.shade500),
        ),
        keyboardType: keyboardType,
        style: GoogleFonts.cairo(color: Colors.black87),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال $label';
          }
          if ((label == "مستوى القلق (1-10)" ||
                  label == "مستوى التوتر (1-10)") &&
              keyboardType == TextInputType.number) {
            final int? level = int.tryParse(value);
            if (level == null || level < 1 || level > 10) {
              return 'الرجاء إدخال رقم بين 1 و 10.';
            }
          }
          return null;
        },
      ),
    );
  }
}
