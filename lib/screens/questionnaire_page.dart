import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // لاستخدام طلبات HTTP
import 'dart:convert'; // لتحويل JSON
import 'package:flutter/foundation.dart'; // لاستخدام debugPrint

// لتسهيل إدارة حالة كل سؤال
class QuestionItem {
  final String questionText;
  final List<String> options;
  String? selectedOption; // لتخزين الإجابة المختارة
  // إذا كانت الإجابة عبارة عن نص حر
  TextEditingController? textController; 
  // إذا كانت الإجابة رقمية (مستوى قلق، توتر)
  int? selectedValue; 

  QuestionItem({
    required this.questionText,
    this.options = const [],
    this.selectedOption,
    this.textController,
    this.selectedValue,
  });
}

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  // مفتاح النموذج للتحقق من صحة المدخلات
  final _formKey = GlobalKey<FormState>();

  // قائمة الأسئلة التي تطابق حقول الـ API
  // **ملاحظة: لقد قمت بتبسيط بعض الأسئلة لجعلها مناسبة لواجهة مستخدم Flutter. يمكنك تخصيصها.**
  late List<QuestionItem> _questions;

  bool _isLoading = false; // حالة للتحميل عند إرسال البيانات

  // **عنوان الـ API الخاص بالاستبيانات**
  final String _apiUrl = "http://127.0.0.1:8000/api/questionnaires"; // **يتناسب مع بيئة الويب**
  
  // **هام: يجب استبدال هذا بـ Auth Token حقيقي من عملية تسجيل الدخول لديك**
  // وأيضاً user_id الخاص بالمستخدم الذي سجل الدخول
  final String _authToken = "YOUR_AUTH_TOKEN_HERE"; // **غير هذا بـ توكن حقيقي!**
  final int _currentUserId = 1; // **غير هذا بـ user_id الحقيقي للمستخدم الذي سجل الدخول!**

  @override
  void initState() {
    super.initState();
    _questions = [
      QuestionItem(
        questionText: "كم مرة شعرت بالتوتر أو القلق خلال الأسبوع الماضي؟",
        options: ["نادراً أو لا على الإطلاق", "عدة أيام", "أكثر من نصف الأيام", "كل يوم تقريباً"],
      ),
      QuestionItem(
        questionText: "ما هو مستوى قلقك من 1 (منخفض جداً) إلى 10 (مرتفع جداً)؟",
        selectedValue: 5, // قيمة مبدئية
      ),
      QuestionItem(
        questionText: "ما هو مستوى توترك من 1 (منخفض جداً) إلى 10 (مرتفع جداً)؟",
        selectedValue: 5, // قيمة مبدئية
      ),
      QuestionItem(
        questionText: "اذكر أي أعراض جسدية مرتبطة بالقلق (مثل خفقان القلب، آلام الرأس):",
        textController: TextEditingController(),
      ),
      QuestionItem(
        questionText: "اذكر أي أعراض نفسية مرتبطة بالقلق (مثل صعوبة التركيز، الأرق):",
        textController: TextEditingController(),
      ),
      QuestionItem(
        questionText: "ما هي المواقف أو الأشياء التي تثير قلقك (المحفزات)؟",
        textController: TextEditingController(),
      ),
      QuestionItem(
        questionText: "ما هي استراتيجيات التأقلم التي تستخدمها للتعامل مع القلق؟",
        textController: TextEditingController(),
      ),
      QuestionItem(
        questionText: "كيف يؤثر القلق على حياتك اليومية (العمل، العلاقات، الأنشطة)؟",
        textController: TextEditingController(),
      ),
      QuestionItem(
        questionText: "ما نوع الدعم الذي تشعر أنك بحاجة إليه؟",
        textController: TextEditingController(),
      ),
    ];
  }

  @override
  void dispose() {
    // التخلص من المتحكمات النصية لتجنب تسرب الذاكرة
    for (var q in _questions) {
      q.textController?.dispose();
    }
    super.dispose();
  }

  // دالة لإرسال بيانات الاستبيان
  Future<void> _submitQuestionnaire() async {
    // التحقق من صحة النموذج بالكامل قبل الإرسال
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('الرجاء الإجابة على جميع الأسئلة المطلوبة.', Colors.orange.shade400);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // جمع البيانات من الأسئلة
    Map<String, dynamic> questionnaireData = {
      'user_id': _currentUserId, // يجب أن يكون user_id حقيقي
      'date': DateTime.now().toIso8601String().split('T')[0], // تنسيق التاريخ Callahan-MM-DD
      'anxiety_level': _questions[1].selectedValue,
      'stress_level': _questions[2].selectedValue,
      'symptoms_frequency': _questions[0].selectedOption,
      'symptoms_severity': 'Moderate', // هذا الحقل غير موجود في الأسئلة حالياً، يمكن إضافته أو تعيين قيمة افتراضية
      'physical_symptoms': _questions[3].textController?.text.trim().isNotEmpty == true ? _questions[3].textController!.text.trim() : 'No data provided',
      'psychological_symptoms': _questions[4].textController?.text.trim().isNotEmpty == true ? _questions[4].textController!.text.trim() : 'No data provided',
      'triggers': _questions[5].textController?.text.trim().isNotEmpty == true ? _questions[5].textController!.text.trim() : 'No data provided',
      'coping_strategy': _questions[6].textController?.text.trim().isNotEmpty == true ? _questions[6].textController!.text.trim() : 'No data provided', // **تم التعديل هنا**
      'daily_life_impact': _questions[7].textController?.text.trim().isNotEmpty == true ? _questions[7].textController!.text.trim() : 'No data provided',
      'support_needs': _questions[8].textController?.text.trim().isNotEmpty == true ? _questions[8].textController!.text.trim() : 'No data provided',
    };

    // طباعة حمولة الطلب للمساعدة في التشخيص
    debugPrint('Sending Questionnaire Data: ${json.encode(questionnaireData)}');

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken', // توكن المصادقة
        },
        body: json.encode(questionnaireData),
      );

      if (response.statusCode == 201) {
        _showSnackBar('✅ تم إرسال الاستبيان بنجاح!', Colors.green.shade400);
        // إعادة تعيين النموذج بعد الإرسال الناجح
        _resetForm();
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل إرسال الاستبيان: ${response.statusCode}';
        if (errorBody['messages'] != null && errorBody['messages'] is Map) {
          Map<String, dynamic> messagesMap = errorBody['messages'];
          List<String> validationErrors = [];
          messagesMap.forEach((field, messages) {
            if (messages is List) {
              validationErrors.addAll(messages.map((msg) => msg.toString()));
            } else if (messages is String) {
              validationErrors.add(messages);
            }
          });
          if (validationErrors.isNotEmpty) {
            errorMessage += '\n' + validationErrors.join('\n');
          }
        } else if (errorBody['message'] != null) {
          errorMessage += '\n' + errorBody['message'];
        }
        _showSnackBar(errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('❌ حدث خطأ في الاتصال: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة لإعادة تعيين النموذج
  void _resetForm() {
    setState(() {
      _questions = [
        QuestionItem(
          questionText: "كم مرة شعرت بالتوتر أو القلق خلال الأسبوع الماضي؟",
          options: ["نادراً أو لا على الإطلاق", "عدة أيام", "أكثر من نصف الأيام", "كل يوم تقريباً"],
        ),
        QuestionItem(
          questionText: "ما هو مستوى قلقك من 1 (منخفض جداً) إلى 10 (مرتفع جداً)؟",
          selectedValue: 5,
        ),
        QuestionItem(
          questionText: "ما هو مستوى توترك من 1 (منخفض جداً) إلى 10 (مرتفع جداً)؟",
          selectedValue: 5,
        ),
        QuestionItem(
          questionText: "اذكر أي أعراض جسدية مرتبطة بالقلق (مثل خفقان القلب، آلام الرأس):",
          textController: TextEditingController(),
        ),
        QuestionItem(
          questionText: "اذكر أي أعراض نفسية مرتبطة بالقلق (مثل صعوبة التركيز، الأرق):",
          textController: TextEditingController(),
        ),
        QuestionItem(
          questionText: "ما هي المواقف أو الأشياء التي تثير قلقك (المحفزات)؟",
          textController: TextEditingController(),
        ),
        QuestionItem(
          questionText: "ما هي استراتيجيات التأقلم التي تستخدمها للتعامل مع القلق؟",
          textController: TextEditingController(),
        ),
        QuestionItem(
          questionText: "كيف يؤثر القلق على حياتك اليومية (العمل، العلاقات، الأنشطة)؟",
          textController: TextEditingController(),
        ),
        QuestionItem(
          questionText: "ما نوع الدعم الذي تشعر أنك بحاجة إليه؟",
          textController: TextEditingController(),
        ),
      ];
      // يجب مسح متحكمات النصوص يدوياً أيضاً إذا تم إعادة إنشائها
      for (var q in _questions) {
        q.textController?.clear();
      }
    });
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.cairo(color: Colors.white)),
          backgroundColor: color,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "الاستبيان", // عنوان الصفحة
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
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // تدرج أزرق سماوي ناعم
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تقييم حالتك النفسية",
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "أجب عن الأسئلة التالية لمساعدتنا على فهم أفضل لحالتك وتوجيهك نحو الموارد المناسبة.",
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.blueGrey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // بناء الأسئلة ديناميكياً
                  ..._questions.map((qItem) {
                    if (qItem.options.isNotEmpty) {
                      // سؤال اختياري (Radio Buttons)
                      return _buildRadioQuestionCard(qItem);
                    } else if (qItem.textController != null) {
                      // سؤال نصي (TextField)
                      return _buildTextQuestionCard(qItem);
                    } else if (qItem.selectedValue != null) {
                      // سؤال رقمي (Slider)
                      return _buildSliderQuestionCard(qItem);
                    }
                    return const SizedBox.shrink(); // في حالة عدم وجود نوع سؤال
                  }).toList(),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submitQuestionnaire,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                      label: Text(
                        _isLoading ? "جارٍ الإرسال..." : "إرسال الإجابات",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
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

  Widget _buildRadioQuestionCard(QuestionItem qItem) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormField<String>( // **تمت إضافة FormField هنا للتحقق من صحة هذا السؤال**
          validator: (value) {
            if (qItem.selectedOption == null || qItem.selectedOption!.isEmpty) {
              return 'الرجاء اختيار خيار.';
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qItem.questionText,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                ...qItem.options.map((option) {
                  return RadioListTile<String>(
                    title: Text(
                      option,
                      style: GoogleFonts.cairo(fontSize: 16, color: Colors.blueGrey.shade700),
                    ),
                    value: option,
                    groupValue: qItem.selectedOption,
                    onChanged: (value) {
                      setState(() {
                        qItem.selectedOption = value;
                        state.didChange(value); // إبلاغ FormField بالتغيير
                      });
                    },
                    activeColor: const Color(0xFF00796B),
                  );
                }).toList(),
                // عرض رسالة الخطأ إذا كان هناك خطأ في التحقق من صحة البيانات
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                    child: Text(
                      state.errorText!,
                      style: GoogleFonts.cairo(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextQuestionCard(QuestionItem qItem) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qItem.questionText,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: qItem.textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'اكتب إجابتك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF0288D1), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50.withOpacity(0.8),
                hintStyle: GoogleFonts.cairo(color: Colors.grey.shade500),
              ),
              style: GoogleFonts.cairo(color: Colors.black87),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'هذا السؤال مطلوب.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderQuestionCard(QuestionItem qItem) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qItem.questionText,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Slider(
              value: qItem.selectedValue!.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: qItem.selectedValue.toString(),
              onChanged: (newValue) {
                setState(() {
                  qItem.selectedValue = newValue.round();
                });
              },
              activeColor: const Color(0xFF00796B),
              inactiveColor: Colors.teal.shade100,
              thumbColor: const Color(0xFF0288D1),
            ),
            Center(
              child: Text(
                'المستوى المختار: ${qItem.selectedValue}',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
