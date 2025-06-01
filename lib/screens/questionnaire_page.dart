import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'home_page.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService(); // إنشاء كائن من ApiService

  // المتحكمات لجمع المدخلات
  final TextEditingController userIdController = TextEditingController(); // إعادة `user_id`
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

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> questionnaireData = {
        "user_id": userIdController.text, // إعادة إرسال `user_id`
        "date": dateController.text,
        "anxiety_level": int.tryParse(anxietyLevelController.text) ?? 0,
        "stress_level": int.tryParse(stressLevelController.text) ?? 0,
        "symptoms_frequency": symptomsFrequencyController.text,
        "symptoms_severity": symptomsSeverityController.text,
        "physical_symptoms": physicalSymptomsController.text,
        "psychological_symptoms": psychologicalSymptomsController.text,
        "triggers": triggersController.text,
        "coping_strategy": copingStrategyController.text,
        "daily_life_impact": dailyLifeImpactController.text,
        "support_needs": supportNeedsController.text,
      };

      bool success = await apiService.sendQuestionnaire(questionnaireData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ تم إرسال الاستبيان بنجاح!')),
        );

        // الانتقال إلى الصفحة الرئيسية بعد الإرسال الناجح
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ حدث خطأ أثناء إرسال الاستبيان!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إرسال الاستبيان')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(userIdController, "User ID", TextInputType.number), // إعادة `user_id`
              buildTextField(dateController, "Date", TextInputType.datetime),
              buildTextField(
                anxietyLevelController,
                "Anxiety Level",
                TextInputType.number,
              ),
              buildTextField(
                stressLevelController,
                "Stress Level",
                TextInputType.number,
              ),
              buildTextField(symptomsFrequencyController, "Symptoms Frequency"),
              buildTextField(symptomsSeverityController, "Symptoms Severity"),
              buildTextField(physicalSymptomsController, "Physical Symptoms"),
              buildTextField(
                psychologicalSymptomsController,
                "Psychological Symptoms",
              ),
              buildTextField(triggersController, "Triggers"),
              buildTextField(copingStrategyController, "Coping Strategy"),
              buildTextField(dailyLifeImpactController, "Daily Life Impact"),
              buildTextField(supportNeedsController, "Support Needs"),
              SizedBox(height: 20),
              ElevatedButton(onPressed: submitForm, child: Text("التالي")),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال $label';
          }
          return null;
        },
      ),
    );
  }
}
