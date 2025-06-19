import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // لاستخدام طلبات HTTP
import 'dart:convert'; // لتحويل JSON
import 'package:intl/intl.dart'; // لتنسيق التاريخ

// 1. نموذج بيانات (Data Model) للملاحظة اليومية
class DailyNote {
  final int id;
  final int userId;
  final DateTime date;
  final String feeling;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyNote({
    required this.id,
    required this.userId,
    required this.date,
    required this.feeling,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor لتحويل JSON إلى كائن DailyNote
  factory DailyNote.fromJson(Map<String, dynamic> json) {
    return DailyNote(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      feeling: json['feeling'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // لتحويل كائن DailyNote إلى JSON للإرسال إلى الـ API
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'date': DateFormat('yyyy-MM-dd').format(date), // تنسيق التاريخ ليتوافق مع Laravel
      'feeling': feeling,
      'description': description,
    };
  }
}

class DailyNotesPage extends StatefulWidget {
  const DailyNotesPage({Key? key}) : super(key: key);

  @override
  _DailyNotesPageState createState() => _DailyNotesPageState();
}

class _DailyNotesPageState extends State<DailyNotesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feelingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // لتخزين التاريخ المختار

  List<DailyNote> _dailyNotes = []; // قائمة لتخزين الملاحظات
  bool _isLoading = false; // حالة للتحميل
  bool _isAdding = false; // حالة لإظهار/إخفاء نموذج الإضافة

  // **عنوان الـ API الخاص بالملاحظات اليومية**
  final String _apiUrl = "http://127.0.0.1:8000/api/daily_notes"; // استخدم IP جهازك أو ngrok

  // **هام: يجب استبدال هذا بـ Auth Token حقيقي من عملية تسجيل الدخول لديك**
  // وأيضاً user_id الخاص بالمستخدم الذي سجل الدخول
  final String _authToken = "YOUR_AUTH_TOKEN_HERE"; // **غير هذا بـ توكن حقيقي!**
  final int _currentUserId = 1; // **غير هذا بـ user_id الحقيقي للمستخدم الذي سجل الدخول!**

  @override
  void initState() {
    super.initState();
    _fetchDailyNotes(); // جلب الملاحظات عند بدء الصفحة
  }

  @override
  void dispose() {
    _feelingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // دالة لجلب الملاحظات اليومية من الـ API
  Future<void> _fetchDailyNotes() async {
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
        final List<dynamic> notesData = data['daily_notes'];
        setState(() {
          _dailyNotes = notesData.map((json) => DailyNote.fromJson(json)).toList();
          // فرز الملاحظات من الأحدث للأقدم
          _dailyNotes.sort((a, b) => b.date.compareTo(a.date));
        });
      } else if (response.statusCode == 401) {
        _showSnackBar('غير مصرح لك بالوصول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      } else {
        _showSnackBar('فشل جلب الملاحظات: ${response.statusCode}', Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الاتصال: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة لإضافة ملاحظة يومية جديدة
  Future<void> _addDailyNote() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('الرجاء ملء جميع الحقول المطلوبة.', Colors.orange.shade400);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newNote = DailyNote(
      id: 0, // ID سيتم تعيينه بواسطة Backend
      userId: _currentUserId,
      date: _selectedDate,
      feeling: _feelingController.text,
      description: _descriptionController.text,
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
        body: json.encode(newNote.toJson()),
      );

      if (response.statusCode == 201) {
        _showSnackBar('✅ تم إضافة الملاحظة بنجاح!', Colors.green.shade400);
        _feelingController.clear();
        _descriptionController.clear();
        setState(() {
          _isAdding = false; // إخفاء نموذج الإضافة
        });
        _fetchDailyNotes(); // إعادة جلب الملاحظات لتحديث القائمة
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل إضافة الملاحظة: ${response.statusCode}';
        if (errorBody['messages'] != null) {
          errorMessage += '\n' + errorBody['messages'].values.expand((msgs) => msgs).join('\n');
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

  // دالة لحذف ملاحظة يومية
  Future<void> _deleteDailyNote(int noteId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('$_apiUrl/$noteId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('🗑️ تم حذف الملاحظة بنجاح!', Colors.grey.shade600);
        _fetchDailyNotes(); // إعادة جلب الملاحظات لتحديث القائمة
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل حذف الملاحظة: ${response.statusCode}';
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
          "ملاحظاتك اليومية",
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
            onPressed: _isLoading ? null : _fetchDailyNotes,
          ),
          IconButton(
            icon: Icon(_isAdding ? Icons.close : Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                _isAdding = !_isAdding; // تبديل حالة إظهار/إخفاء نموذج الإضافة
                if (!_isAdding) { // إذا تم إخفاء النموذج، قم بمسح الحقول
                  _feelingController.clear();
                  _descriptionController.clear();
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
                  "سجل مشاعرك وأفكارك اليومية لتتبع تقدمك.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              // نموذج إضافة ملاحظة جديدة
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
                            "إضافة ملاحظة جديدة",
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00796B),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _feelingController,
                            decoration: InputDecoration(
                              labelText: "الشعور (مثال: سعيد، قلق، هادئ)",
                              labelStyle: GoogleFonts.cairo(),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: const Icon(Icons.mood, color: Color(0xFF0288D1)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال الشعور.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: "الوصف (تفاصيل يومك ومشاعرك)",
                              labelStyle: GoogleFonts.cairo(),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              prefixIcon: const Icon(Icons.description, color: Color(0xFF0288D1)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال الوصف.';
                              }
                              return null;
                            },
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
                              onPressed: _isLoading ? null : _addDailyNote,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                _isLoading ? "جارٍ الإضافة..." : "إضافة ملاحظة",
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
              Expanded(
                child: _isLoading && _dailyNotes.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                    : _dailyNotes.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد ملاحظات يومية بعد. اضغط على علامة الزائد لإضافة واحدة!',
                              style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _dailyNotes.length,
                            itemBuilder: (context, index) {
                              final note = _dailyNotes[index];
                              return _buildDailyNoteCard(note);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyNoteCard(DailyNote note) {
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
                  note.feeling,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(note.date),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              note.description,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(note.id), // تأكيد الحذف
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لتأكيد الحذف قبل التنفيذ
  void _confirmDelete(int noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الحذف", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Text("هل أنت متأكد أنك تريد حذف هذه الملاحظة؟", style: GoogleFonts.cairo()),
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
                _deleteDailyNote(noteId); // تنفيذ الحذف
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
