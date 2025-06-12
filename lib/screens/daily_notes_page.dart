import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // لاستخدام DateFormat

// نموذج لبيانات الملاحظة اليومية (مبسط للاستخدام المحلي فقط)
class DailyNote {
  final String date;
  final String feeling;
  final String description;
  final String localId; // معرف محلي لتمييز الملاحظات مؤقتاً

  DailyNote({
    required this.date,
    required this.feeling,
    required this.description,
    required this.localId,
  });
}

class DailyNotesPage extends StatefulWidget {
  const DailyNotesPage({Key? key}) : super(key: key);

  @override
  _DailyNotesPageState createState() => _DailyNotesPageState();
}

class _DailyNotesPageState extends State<DailyNotesPage> {
  final _formKey = GlobalKey<FormState>(); // مفتاح النموذج للتحقق من صحة المدخلات
  // تم إزالة userIdController لأنه لا يوجد ربط مستخدم حالياً
  final TextEditingController dateController = TextEditingController();
  final TextEditingController feelingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // قائمة لتخزين الملاحظات محلياً (ستفقد عند إعادة تشغيل التطبيق)
  final List<DailyNote> _dailyNotes = [];

  @override
  void initState() {
    super.initState();
    // قم بتعيين تاريخ اليوم كقيمة افتراضية لحقل التاريخ
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    // تم إزالة userIdController.dispose() لأنه لا يوجد
    dateController.dispose();
    feelingController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // دالة لإضافة ملاحظة جديدة إلى القائمة المحلية
  void _submitNote() {
    if (_formKey.currentState!.validate()) {
      final newNote = DailyNote(
        date: dateController.text,
        feeling: feelingController.text,
        description: descriptionController.text,
        localId: DateTime.now().millisecondsSinceEpoch.toString(), // معرف فريد مؤقت
      );

      setState(() {
        _dailyNotes.insert(0, newNote); // إضافة الملاحظة في بداية القائمة (الأحدث أولاً)
        // لا حاجة للفرز هنا لأننا نضيفها في البداية
      });

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ تم إضافة الملاحظة بنجاح (محلية)!',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.green.shade400,
        ),
      );

      // مسح الحقول بعد الإرسال الناجح
      feelingController.clear();
      descriptionController.clear();
      // يمكن إعادة تعيين التاريخ لليوم الحالي إذا أردت
      // dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
        // تم إزالة زر التحديث لأنه لا يوجد ربط بـ API حالياً
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: Colors.white),
        //     onPressed: _fetchDailyNotes,
        //   ),
        // ],
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
                  "سجل مشاعرك وأفكارك اليومية لمتابعة حالتك النفسية.",
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
                    children: [
                      // تم إزالة حقل User ID لأنه لا يوجد ربط مستخدم حالياً
                      // _buildTextField(
                      //   controller: userIdController,
                      //   label: 'معرف المستخدم (User ID)',
                      //   icon: Icons.person,
                      //   keyboardType: TextInputType.number,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'الرجاء إدخال معرف المستخدم';
                      //     }
                      //     if (int.tryParse(value) == null) {
                      //       return 'الرجاء إدخال رقم صحيح';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      _buildTextField(
                        controller: dateController,
                        label: 'التاريخ',
                        icon: Icons.calendar_today,
                        readOnly: true, // لمنع الكتابة المباشرة
                        onTap: () async { // لفتح منتقي التاريخ
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  // تطبيق خط القاهرة على منتقي التاريخ
                                  textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
                                  colorScheme: ColorScheme.light(
                                    primary: const Color(0xFF0288D1), // لون الأساسي
                                    onPrimary: Colors.white, // لون النص على الأساسي
                                    onSurface: Colors.black, // لون النص على السطح
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF0288D1), // لون زر النص
                                      textStyle: GoogleFonts.cairo(), // تطبيق خط القاهرة على زر النص
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: feelingController,
                        label: 'ما هو شعورك اليوم؟',
                        icon: Icons.mood,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء وصف شعورك';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: descriptionController,
                        label: 'اكتب وصفاً موجزاً لليوم',
                        icon: Icons.notes,
                        maxLines: 3, // للسماح بأكثر من سطر
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة وصف لليوم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitNote,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            "إضافة ملاحظة",
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0288D1), // لون أزرق جذاب
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8, // ظل للزر
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // قسم عرض الملاحظات
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "ملاحظاتك السابقة:",
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _dailyNotes.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد ملاحظات حالياً. ابدأ بإضافة واحدة!",
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _dailyNotes.length,
                        itemBuilder: (context, index) {
                          final note = _dailyNotes[index];
                          return _buildNoteCard(note);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء حقل إدخال (TextFormField) مع تصميم موحد
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
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
        errorStyle: GoogleFonts.cairo(color: Colors.red.shade700, fontSize: 12), // نمط رسالة الخطأ
      ),
      style: GoogleFonts.cairo(color: Colors.black87),
      validator: validator,
    );
  }

  // دالة مساعدة لبناء بطاقة عرض الملاحظة
  Widget _buildNoteCard(DailyNote note) {
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
                  note.date,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                // تم إزالة عرض معرف المستخدم لأننا لا نستخدمه حالياً
                // Text(
                //   'ID: ${note.userId}',
                //   style: GoogleFonts.cairo(
                //     fontSize: 14,
                //     color: Colors.grey.shade600,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'الشعور: ${note.feeling}',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'الوصف: ${note.description}',
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
            // تم إزالة عرض وقت الإنشاء لأننا لا نستخدمه حالياً
            // if (note.createdAt != null)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 8.0),
            //     child: Text(
            //       'تم الإنشاء: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(note.createdAt!))}',
            //       style: GoogleFonts.cairo(
            //         fontSize: 12,
            //         color: Colors.grey.shade500,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
