import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // لاستخدام طلبات HTTP
import 'dart:convert'; // لتحويل JSON
import 'package:intl/intl.dart'; // لتنسيق التاريخ

// 1. نموذج بيانات (Data Model) للنظام الغذائي والعادات
class DietAndHabit {
  final int id;
  final int userId;
  final DateTime date;
  final String? dietDescription; // قابل للقيم الفارغة
  final String? badHabits; // قابل للقيم الفارغة
  final DateTime createdAt;
  final DateTime updatedAt;

  DietAndHabit({
    required this.id,
    required this.userId,
    required this.date,
    this.dietDescription,
    this.badHabits,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor لتحويل JSON إلى كائن DietAndHabit
  factory DietAndHabit.fromJson(Map<String, dynamic> json) {
    return DietAndHabit(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      dietDescription: json['diet_description'],
      badHabits: json['bad_habits'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // لتحويل كائن DietAndHabit إلى JSON للإرسال إلى الـ API
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'date': DateFormat('yyyy-MM-dd').format(date), // تنسيق التاريخ ليتوافق مع Laravel
      'diet_description': dietDescription,
      'bad_habits': badHabits,
    };
  }
}

class DietAndHabitPage extends StatefulWidget {
  const DietAndHabitPage({Key? key}) : super(key: key);

  @override
  _DietAndHabitPageState createState() => _DietAndHabitPageState();
}

class _DietAndHabitPageState extends State<DietAndHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dietDescriptionController = TextEditingController();
  final TextEditingController _badHabitsController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // لتخزين التاريخ المختار

  List<DietAndHabit> _entries = []; // قائمة لتخزين الإدخالات
  bool _isLoading = false; // حالة للتحميل
  bool _isAdding = false; // حالة لإظهار/إخفاء نموذج الإضافة

  // **عنوان الـ API الخاص بـ "النظام الغذائي والعادات"**
  final String _apiUrl = "http://127.0.0.1:8000/api/diet_and_habits"; // استخدم IP جهازك أو ngrok

  // **هام: يجب استبدال هذا بـ Auth Token حقيقي من عملية تسجيل الدخول لديك**
  // وأيضاً user_id الخاص بالمستخدم الذي سجل الدخول
  final String _authToken = "YOUR_AUTH_TOKEN_HERE"; // **غير هذا بـ توكن حقيقي!**
  final int _currentUserId = 1; // **غير هذا بـ user_id الحقيقي للمستخدم الذي سجل الدخول!**

  // قائمة الاقتراحات الثابتة للنظام الغذائي والعادات
  final List<Map<String, String>> _dietSuggestions = [
    {
      'title': 'نظام غذائي متوازن',
      'description': 'يشمل الفواكه والخضروات والبروتينات الخالية من الدهون والحبوب الكاملة.',
    },
    {
      'title': 'ترطيب الجسم',
      'description': 'اشرب ما لا يقل عن 8 أكواب من الماء يومياً.',
    },
    {
      'title': 'الحد من السكريات المصنعة',
      'description': 'قلل من تناول المشروبات السكرية والحلويات المصنعة.',
    },
    {
      'title': 'تجنب الوجبات السريعة',
      'description': 'قلل من استهلاك الوجبات السريعة والأطعمة المعالجة.',
    },
    {
      'title': 'النوم الكافي',
      'description': 'احرص على النوم لمدة 7-9 ساعات يومياً.',
    },
    {
      'title': 'النشاط البدني المنتظم',
      'description': 'مارس الرياضة لمدة 30 دقيقة على الأقل معظم أيام الأسبوع.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchEntries(); // جلب الإدخالات عند بدء الصفحة
  }

  @override
  void dispose() {
    _dietDescriptionController.dispose();
    _badHabitsController.dispose();
    super.dispose();
  }

  // دالة لجلب الإدخالات من الـ API
  Future<void> _fetchEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> entriesData = data['diet_and_habits'];
        setState(() {
          _entries = entriesData.map((json) => DietAndHabit.fromJson(json)).toList();
          // فرز الإدخالات من الأحدث للأقدم
          _entries.sort((a, b) => b.date.compareTo(a.date));
        });
      } else if (response.statusCode == 401) {
        _showSnackBar('غير مصرح لك بالوصول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      } else {
        _showSnackBar('فشل جلب الإدخالات: ${response.statusCode}', Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الاتصال: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة لإضافة إدخال جديد
  Future<void> _addEntry() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('الرجاء ملء جميع الحقول المطلوبة.', Colors.orange.shade400);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newEntry = DietAndHabit(
      id: 0, // ID سيتم تعيينه بواسطة Backend
      userId: _currentUserId,
      date: _selectedDate,
      dietDescription: _dietDescriptionController.text.isNotEmpty ? _dietDescriptionController.text : null, // إرسال null إذا كانت فارغة
      badHabits: _badHabitsController.text.isNotEmpty ? _badHabitsController.text : null, // إرسال null إذا كانت فارغة
      createdAt: DateTime.now(), // سيتم تجاوزها بواسطة Backend
      updatedAt: DateTime.now(), // سيتم تجاوزها بواسطة Backend
    );

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode(newEntry.toJson()),
      );

      if (response.statusCode == 201) {
        _showSnackBar('✅ تم إضافة الإدخال بنجاح!', Colors.green.shade400);
        _dietDescriptionController.clear();
        _badHabitsController.clear();
        setState(() {
          _isAdding = false; // إخفاء نموذج الإضافة
        });
        _fetchEntries(); // إعادة جلب الإدخالات لتحديث القائمة
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل إضافة الإدخال: ${response.statusCode}';
        if (errorBody['messages'] != null) {
          // Flatten messages to display
          List<String> validationErrors = [];
          if (errorBody['messages'] is Map) {
            errorBody['messages'].forEach((field, msgs) {
              if (msgs is List) {
                validationErrors.addAll(msgs.map((msg) => msg.toString()));
              } else if (msgs is String) {
                validationErrors.add(msgs);
              }
            });
          }
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

  // دالة لحذف إدخال
  Future<void> _deleteEntry(int entryId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('$_apiUrl/$entryId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('🗑️ تم حذف الإدخال بنجاح!', Colors.grey.shade600);
        _fetchEntries(); // إعادة جلب الإدخالات لتحديث القائمة
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل حذف الإدخال: ${response.statusCode}';
        if (errorBody['message'] != null) {
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

  // دالة لعرض SnackBar
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

  // دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00796B), // لون رئيسي للتقويم
              onPrimary: Colors.white, // لون النص على اللون الرئيسي
              onSurface: Colors.black, // لون النص على السطح (أيام الأسبوع)
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00796B), // لون أزرار النص في التقويم
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "نظامك الغذائي وعاداتك",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _fetchEntries,
          ),
          IconButton(
            icon: Icon(_isAdding ? Icons.close : Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                _isAdding = !_isAdding; // تبديل حالة إظهار/إخفاء نموذج الإضافة
                if (!_isAdding) { // إذا تم إخفاء النموذج، قم بمسح الحقول
                  _dietDescriptionController.clear();
                  _badHabitsController.clear();
                  _selectedDate = DateTime.now();
                }
              });
            },
          ),
        ],
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "سجل عاداتك الغذائية والسلوكية لتتبع تقدمك نحو حياة صحية أفضل.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              // نموذج إضافة إدخال جديد
              if (_isAdding)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "إضافة إدخال جديد",
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00796B),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _dietDescriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "وصف النظام الغذائي (مثال: وجبات اليوم، كمية الماء)",
                              labelStyle: GoogleFonts.cairo(),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: const Icon(Icons.food_bank, color: Color(0xFF0288D1)),
                            ),
                            // لا يوجد validator هنا لأن الحقل nullable في Backend
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _badHabitsController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "العادات السيئة التي تحاول تجنبها (مثال: التدخين، الأكل الزائد)",
                              labelStyle: GoogleFonts.cairo(),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: const Icon(Icons.smoking_rooms_sharp, color: Color(0xFF0288D1)),
                            ),
                            // لا يوجد validator هنا لأن الحقل nullable في Backend
                          ),
                          const SizedBox(height: 15),
                          ListTile(
                            title: Text(
                              "التاريخ: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                              style: GoogleFonts.cairo(fontSize: 16, color: Colors.blueGrey.shade700),
                            ),
                            trailing: const Icon(Icons.calendar_today, color: Color(0xFF0288D1)),
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _addEntry,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                _isLoading ? "جارٍ الإضافة..." : "إضافة إدخال",
                                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00796B),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // قسم الاقتراحات (جديد)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    "اقتراحات لأنظمة غذائية وعادات صحية",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  collapsedBackgroundColor: Colors.teal.shade50.withOpacity(0.5),
                  backgroundColor: Colors.teal.shade100.withOpacity(0.7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  children: _dietSuggestions.map((suggestion) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion['title']!,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            suggestion['description']!,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                          const Divider(color: Colors.teal, height: 15),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10), // مسافة بعد الاقتراحات

              // قائمة الإدخالات الشخصية للمستخدم
              Expanded(
                child: _isLoading && _entries.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                    : _entries.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد إدخالات للنظام الغذائي والعادات بعد. اضغط على علامة الزائد لإضافة واحدة!',
                              style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _entries.length,
                            itemBuilder: (context, index) {
                              final entry = _entries[index];
                              return _buildEntryCard(entry);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntryCard(DietAndHabit entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تاريخ: ${DateFormat('yyyy-MM-dd').format(entry.date)}",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(entry.id), // تأكيد الحذف
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (entry.dietDescription != null && entry.dietDescription!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "وصف النظام الغذائي:",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  Text(
                    entry.dietDescription!,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            if (entry.badHabits != null && entry.badHabits!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "العادات السيئة:",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  Text(
                    entry.badHabits!,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                ],
              ),
            if ((entry.dietDescription == null || entry.dietDescription!.isEmpty) &&
                (entry.badHabits == null || entry.badHabits!.isEmpty))
              Text(
                'لا توجد تفاصيل لهذا اليوم.',
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }

  // دالة لتأكيد الحذف قبل التنفيذ
  void _confirmDelete(int entryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الحذف", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Text("هل أنت متأكد أنك تريد حذف هذا الإدخال؟", style: GoogleFonts.cairo()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey.shade700)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
                _deleteEntry(entryId); // تنفيذ الحذف
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("حذف", style: GoogleFonts.cairo(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
