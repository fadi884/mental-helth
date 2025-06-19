import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // استيراد حزمة url_launcher
import 'package:http/http.dart' as http; // لاستخدام طلبات HTTP
import 'dart:convert'; // لتحويل JSON


class Tip {
  final int id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tip({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// 2. نموذج بيانات (Data Model) للمورد التعليمي (EducationalResource)
class EducationalResource {
  final int id;
  final int tipId;
  final String title;
  final String description;
  final String link; // رابط المورد
  final DateTime createdAt;
  final DateTime updatedAt;

  EducationalResource({
    required this.id,
    required this.tipId,
    required this.title,
    required this.description,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EducationalResource.fromJson(Map<String, dynamic> json) {
    return EducationalResource(
      id: json['id'],
      tipId: json['tip_id'],
      title: json['title'],
      description: json['description'],
      link: json['link'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class EducationalResourcesPage extends StatefulWidget {
  const EducationalResourcesPage({Key? key}) : super(key: key);

  @override
  _EducationalResourcesPageState createState() => _EducationalResourcesPageState();
}

class _EducationalResourcesPageState extends State<EducationalResourcesPage> {
  List<EducationalResource> _educationalResources = []; // قائمة لتخزين الموارد المجلوبة
  bool _isLoading = false; // حالة للتحميل

  // **عنوان الـ API الخاص بالموارد التعليمية**
  final String _apiUrl = "http://127.0.0.1:8000/api/educational_resources"; // استخدم IP جهازك أو ngrok

  // **هام: يجب استبدال هذا بـ Auth Token حقيقي من عملية تسجيل الدخول لديك**
  final String _authToken = "YOUR_AUTH_TOKEN_HERE"; // **غير هذا بـ توكن حقيقي!**

  // قائمة بالكتب المقترحة (بيانات ثابتة)
  final List<Map<String, dynamic>> _suggestedBooks = const [
    {
      'title': 'كيف يمكن لعقلك أن يشفي جسدك',
      'author': 'ديفيد هاميلتون',
      'description':
          'يشارك تفسيرات لاستخدام الصور والتخيل كطريقة للشفاء من الألم والأمراض، ويشجع على تولي مسؤولية تحقيق السعادة.',
      'icon': Icons.menu_book,
      'url':
          'https://www.jarir.com/sa-ar/books/9780857945036',
    },
    {
      'title': 'الصحة النفسية: نهج يركز على الشخص',
      'author': 'نيكولاس بروكتر',
      'description':
          'يساعد على زيادة فهم الصحة النفسية والأمراض وطرق الشفاء، مع شرح مفاهيم إنسانية مثل التعاطف.',
      'icon': Icons.self_improvement,
      'url':
          'https://www.amazon.com/Mental-Health-Person-centred-Approach-Procter/dp/0729541249',
    },
    {
      'title': 'التعافي الشخصي والمرض العقلي: دليل لمتخصصي الصحة النفسية',
      'author': 'غير مذكور في المقطع المقدم',
      'description':
          'يعتمد على إطار عمل فريد يركز على تحول العقل إلى الإيجابية، ويستكشف أبعاد جديدة للتعافي.',
      'icon': Icons.healing,
      'url':
          'https://www.amazon.com/Personal-Recovery-Mental-Illness-Professionals/dp/1118314115',
    },
    {
      'title': 'دليل عملي لاضطرابات الصحة العقلية والتعلم لكل معلم',
      'author': 'غير مذكور في المقطع المقدم',
      'description':
          'يقدم دليلاً لفهم قضايا نفسية مهمة مثل اضطراب ما بعد الصدمة والتوحد، وكيفية التعامل معها بتمارين عملية.',
      'icon': Icons.school,
      'url':
          'https://www.amazon.com/Practical-Mental-Health-Learning-Disorders/dp/1944876251',
    },
    {
      'title':
          'دليل المهارات الاجتماعية: إدارة الخجل وتحسين محادثاتك وتكوين صداقات دون التخلي عن هويتك',
      'author': 'Chris Macleod',
      'description':
          'يسهل معرفة الطرق المناسبة لتحسين المهارات الاجتماعية، مع الاحتفاظ بالهوية الشخصية.',
      'icon': Icons.people,
      'url':
          'https://www.amazon.com/Social-Skills-Guidebook-Conversations-Without/dp/1492147774',
    },
    {
      'title': 'المقابلات التحفيزية: مساعدة الناس على التغيير',
      'author': 'William R. Miller & Stephen Rollnick',
      'description':
          'يساعد في تحفيز عملية التغيير، إذ يقدم الطرق المناسبة للتواصل الفعّال والدعم المطلوبة للأشخاص.',
      'icon': Icons.chat,
      'url':
          'https://www.amazon.com/Motivational-Interviewing-Third-Helping-People/dp/1609182276',
    },
    {
      'title':
          'العلاج المعرفي بين الأشخاص لعلاج فقدان الشهية العصبي: نموذج مودسلي',
      'author':
          'Janet Treasure, Ulrike Schmidt, Sarah Williams',
      'description':
          'يساعد المرء على التعافي من مرض فقدان الشهية العصبي، ومعالجة آثاره السلبية على الأشخاص.',
      'icon': Icons.food_bank,
      'url':
          'https://www.amazon.com/Cognitive-Interpersonal-Therapy-Workbook-Treating-Anorexia/dp/041550974X',
    },
    {
      'title':
          'تغيير العقول: دليل الانتقال إلى الصحة العقلية لك ولعائلتك ولأصدقائك',
      'author': 'Dr. Gail Saltz',
      'description':
          'يساعد على فهم مشكلات الصحة النفسية، وكذلك تقديم المساعدة لأي شخص مهتم بصحته العقلية.',
      'icon': Icons.psychology,
      'url':
          'https://www.amazon.com/Changing-Minds-Mental-Health-Family/dp/1250106429',
    },
    {
      'title': 'لا تنعتني بالمجنون: 33 صوتًا يتحدثون حول الصحة العقلية',
      'author': 'Kelly Jensen',
      'description':
          'يقدم قصصاً لأشخاص تعاملوا مع المرض العقلي، ويساعد على الوصول إلى فهم أفضل والقضاء على الأساطير.',
      'icon': Icons.campaign,
      'url':
          'https://www.amazon.com/Dont-Call-Crazy-Voices-Conversation/dp/1626727787',
    },
    {
      'title':
          'اشعر بالخوف وافعل ذلك على أي حال: كيف تحول مخاوفك وترددك إلى ثقة وعمل',
      'author': 'Susan Jeffers',
      'description':
          'يقدم مجموعة من الطرق التي تتيح لك التعامل مع مخاوفك، والسعي للتغلب عليها.',
      'icon': Icons.run_circle,
      'url':
          'https://www.amazon.com/Feel-Fear-Do-Anyway-Confidence/dp/034548742X',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchEducationalResources(); // جلب الموارد عند بدء الصفحة
  }

  // دالة لجلب الموارد التعليمية من الـ API
  Future<void> _fetchEducationalResources() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken', // توكن المصادقة
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> resourcesData = data['educational_resources'];
        setState(() {
          _educationalResources = resourcesData.map((json) => EducationalResource.fromJson(json)).toList();
        });
      } else if (response.statusCode == 401) {
        _showSnackBar('غير مصرح لك بالوصول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      } else {
        _showSnackBar('فشل جلب الموارد: ${response.statusCode}', Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الاتصال: $e', Colors.red.shade400);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "الموارد التعليمية", // عنوان الصفحة
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
            onPressed: _isLoading ? null : _fetchEducationalResources,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
            ], // تدرج أزرق سماوي ناعم
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
                  "استكشف مكتبتنا من الموارد التي تدعم صحتك النفسية.",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "مقالات وأدلة وفيديوهات (من قاعدة البيانات):",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "نقدم لك مجموعة متنوعة من الموارد التعليمية المصممة لمساعدتك على فهم أفضل للصحة النفسية، وتطوير استراتيجيات التعامل الفعالة، وتحسين رفاهيتك العامة.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),

                // عرض الموارد التعليمية المجلوبة من الـ Backend
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                    : _educationalResources.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد موارد تعليمية متاحة حالياً.',
                              style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            children: _educationalResources.map((resource) {
                              return _buildEducationalResourceCard(context, resource);
                            }).toList(),
                          ),

                const SizedBox(height: 30), // فاصل بين الأقسام
                // القسم الجديد: كتب مقترحة (لا يزال ثابتًا)
                Text(
                  "كتب مقترحة لرحلتك:",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  children: _suggestedBooks.map((book) {
                    return _buildBookCard(
                      context,
                      book['title'] as String,
                      book['author'] as String,
                      book['description'] as String,
                      book['icon'] as IconData,
                      book['url'] as String?,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.indigo.shade700,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "المزيد من الموارد قريباً!",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "نعمل باستمرار على إضافة محتوى جديد ومفيد لتعزيز رحلتك التعليمية.",
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

  // دالة مساعدة لبناء بطاقة المورد التعليمي (من الـ Backend)
  Widget _buildEducationalResourceCard(
    BuildContext context,
    EducationalResource resource,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 30, color: Colors.teal.shade700), // يمكنك اختيار أيقونة ديناميكية إذا أردت
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    resource.title,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'الوصف: ${resource.description}',
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'الرابط: ${resource.link}',
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(resource.link);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    ); // فتح الرابط في متصفح خارجي
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '❌ تعذر فتح الرابط. يرجى التحقق من اتصالك بالإنترنت.',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: Colors.red.shade400,
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.open_in_new, // أيقونة لفتح رابط
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  'انتقل إلى المورد',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء بطاقة الكتاب المقترح (لا تزال ثابتة)
  Widget _buildBookCard(
    BuildContext context,
    String title,
    String author,
    String description,
    IconData icon,
    String? url, // استقبال الرابط
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Colors.blueGrey.shade700),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'المؤلف: $author',
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: url != null
                    ? () async {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          ); // فتح الرابط في متصفح خارجي
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '❌ تعذر فتح الرابط. يرجى التحقق من اتصالك بالإنترنت.',
                                style: GoogleFonts.cairo(),
                              ),
                              backgroundColor: Colors.red.shade400,
                            ),
                          );
                        }
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'لا يوجد رابط مباشر لهذا الكتاب حالياً. يمكنك البحث عنه يدوياً.',
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.link, size: 18, color: Colors.white),
                label: Text(
                  url != null ? 'انتقل إلى الكتاب' : 'ابحث عن الكتاب',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
