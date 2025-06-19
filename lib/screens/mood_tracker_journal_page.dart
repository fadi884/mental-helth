import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // لتنسيق التواريخ

// نموذج لمدخل يومي للحالة المزاجية والمذكرات
class MoodEntry {
  final String id;
  final DateTime date;
  final String mood; // لتمثيل الرموز التعبيرية أو الوصف النصي
  final String? journalEntry; // ملاحظات المستخدم

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.journalEntry,
  });
}

class MoodTrackerJournalPage extends StatefulWidget {
  const MoodTrackerJournalPage({Key? key}) : super(key: key);

  @override
  _MoodTrackerJournalPageState createState() => _MoodTrackerJournalPageState();
}

class _MoodTrackerJournalPageState extends State<MoodTrackerJournalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _journalController = TextEditingController();
  String? _selectedMood; // الحالة المزاجية المختارة

  // قائمة بالرموز التعبيرية للحالات المزاجية
  final List<String> _moodEmojis = [
    '😊', // سعيد جداً
    '🙂', // سعيد
    '😐', // عادي
    '😟', // قلق/حزين
    '😠', // غاضب
    '😩', // متعب/مرهق
    '🤩', // متحمس
    '😴', // نعسان
  ];

  // قائمة لتخزين الإدخالات المزاجية محلياً (ستفقد عند إعادة تشغيل التطبيق)
  final List<MoodEntry> _moodEntries = [];

  @override
  void initState() {
    super.initState();
    // يمكن إضافة بعض البيانات الوهمية للاختبار
    // _moodEntries.add(MoodEntry(
    //   id: DateTime.now().add(Duration(days: -1)).millisecondsSinceEpoch.toString(),
    //   date: DateTime.now().add(Duration(days: -1)),
    //   mood: '🙂',
    //   journalEntry: 'كان يوماً جيداً في العمل.',
    // ));
    // _moodEntries.add(MoodEntry(
    //   id: DateTime.now().add(Duration(days: -2)).millisecondsSinceEpoch.toString(),
    //   date: DateTime.now().add(Duration(days: -2)),
    //   mood: '😟',
    //   journalEntry: 'شعرت ببعض التوتر اليوم.',
    // ));
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  // دالة لإضافة إدخال مزاجي جديد
  void _addMoodEntry() {
    if (_formKey.currentState!.validate() && _selectedMood != null) {
      final newEntry = MoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // معرف فريد
        date: DateTime.now(),
        mood: _selectedMood!,
        journalEntry: _journalController.text.isNotEmpty ? _journalController.text : null,
      );

      setState(() {
        _moodEntries.insert(0, newEntry); // إضافة المدخل في بداية القائمة (الأحدث أولاً)
        _journalController.clear();
        _selectedMood = null; // إعادة تعيين المزاج المختار
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ تم تسجيل حالتك المزاجية والمذكرات بنجاح (محلية)!',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.green.shade400,
        ),
      );
    } else if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الرجاء اختيار حالتك المزاجية قبل الإضافة.',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange.shade400,
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
          "تتبع حالتك ومذكراتك",
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "سجل حالتك المزاجية اليومية وملاحظاتك لمتابعة تقدمك وفهم مشاعرك.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "كيف تشعر اليوم؟",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // اختيار الحالة المزاجية باستخدام الأيقونات/الإيموجي
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _moodEmojis.map((emoji) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedMood = emoji;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _selectedMood == emoji
                                      ? Colors.blue.shade100.withOpacity(0.8)
                                      : Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: _selectedMood == emoji ? Colors.blue.shade700 : Colors.grey.shade300,
                                    width: _selectedMood == emoji ? 2 : 1,
                                  ),
                                  boxShadow: _selectedMood == emoji
                                      ? [
                                          BoxShadow(
                                            color: Colors.blue.shade200.withOpacity(0.5),
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _journalController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'اكتب عن يومك هنا...',
                          prefixIcon: Icon(Icons.edit_note, color: Colors.blueGrey.shade600),
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
                        style: GoogleFonts.cairo(color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addMoodEntry,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            "سجل حالتك المزاجية",
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B), // لون أخضر داكن
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // قسم عرض الملاحظات السابقة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "سجلاتك السابقة:",
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _moodEntries.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد سجلات حالياً. ابدأ بإضافة واحدة!",
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _moodEntries.length,
                        itemBuilder: (context, index) {
                          final entry = _moodEntries[index];
                          return _buildMoodEntryCard(entry);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء بطاقة عرض إدخال الحالة المزاجية
  Widget _buildMoodEntryCard(MoodEntry entry) {
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
                  DateFormat('dd MMMM yyyy - HH:mm', 'ar').format(entry.date), // تنسيق التاريخ والوقت
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  entry.mood, // عرض الرمز التعبيري للحالة المزاجية
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            if (entry.journalEntry != null && entry.journalEntry!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'مذكراتي:',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              Text(
                entry.journalEntry!,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
