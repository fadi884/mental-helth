import 'dart:math'; // لاستخدام Random
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts

// هذا هو الـ Widget الخاص بواجهة الاسترخاء
class RelaxScreen extends StatefulWidget {
  // لا يمكن أن يكون StatefulWidget 'const' إذا كانت حالته تتغير، ولكن يمكن أن يكون الـ constructor نفسه 'const'
  // إذا لم يكن يستقبل معلمات متغيرة. في هذه الحالة، سنبقيه بدون 'const' لتجنب مشاكل لاحقاً.
  // للإزالة المشكلة في HomeePage، سنزيل 'const' من استدعاء RelaxScreen()
  const RelaxScreen({Key? key}) : super(key: key); // إضافة const constructor

  @override
  _RelaxScreenState createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> with TickerProviderStateMixin {
  // قائمة لتخزين البالونات النشطة
  final List<Balloon> balloons = [];
  // لتوليد قيم عشوائية
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // ابدأ في توليد البالونات بعد فترة قصيرة
    // هذا يضمن أن 'context' جاهز لاستخدام MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneratingBalloons();
    });
  }

  // دالة لبدء توليد البالونات بشكل متكرر
  void _startGeneratingBalloons() {
    // استخدم Future.delayed لتوليد بالون جديد كل 1 إلى 3 ثوانٍ بشكل عشوائي
    Future.delayed(Duration(seconds: 1 + _random.nextInt(3)), () {
      // تأكد أن الـ widget ما زال موجوداً في شجرة الـ widgets قبل إضافة بالون جديد
      if (mounted) {
        _addBalloon();
        _startGeneratingBalloons(); // استدعاء ذاتي لتوليد البالونات باستمرار
      }
    });
  }

  // دالة لإضافة بالون جديد إلى الشاشة
  void _addBalloon() {
    // حساب موقع البداية الأفقي للبالون بشكل عشوائي
    // (عرض الشاشة - عرض البالون) لضمان عدم خروجه عن الحدود
    final double startX = _random.nextDouble() * (MediaQuery.of(context).size.width - 80); // 80 هو عرض البالون التقريبي
    // البالون يبدأ من أسفل الشاشة
    final double startY = MediaQuery.of(context).size.height + 50; // +50 لضمان بدايته من خارج الشاشة من الأسفل
    // البالون ينتهي فوق الشاشة
    final double endY = -100; // -100 لضمان خروجه بالكامل من الشاشة من الأعلى

    // مدة صعود البالون بشكل عشوائي (من 8 إلى 15 ثانية)
    final Duration duration = Duration(seconds: 8 + _random.nextInt(8));
    // لون عشوائي للبالون
    final Color color = Color.fromRGBO(
      _random.nextInt(200) + 50, // ضمان ألوان فاتحة أكثر
      _random.nextInt(200) + 50,
      _random.nextInt(200) + 50,
      1,
    );

    // تحديث الحالة لإضافة البالون الجديد
    setState(() {
      balloons.add(
        Balloon(
          // مفتاح فريد لكل بالون لتمكين Flutter من تتبعه بشكل صحيح
          key: UniqueKey(),
          startX: startX,
          startY: startY,
          endY: endY,
          duration: duration,
          color: color,
          // دالة تُستدعى عندما يتم تفجير البالون أو خروجه من الشاشة
          onTap: (key) {
            _popBalloon(key);
          },
        ),
      );
    });
  }

  // دالة لإزالة بالون من القائمة (عند تفجيره أو خروجه من الشاشة)
  void _popBalloon(Key key) {
    setState(() {
      // إزالة البالون الذي يطابق المفتاح المحدد
      balloons.removeWhere((balloon) => balloon.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط التطبيق العلوي
      extendBodyBehindAppBar: true, // جعل الجسم يمتد خلف شريط التطبيق
      appBar: AppBar(
        title: Text(
          "وضع الاسترخاء", // عنوان باللغة العربية
          style: GoogleFonts.cairo( // استخدام GoogleFonts
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container( // إضافة تدرج لوني لشريط التطبيق
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // شفافية الخلفية
        elevation: 0, // إزالة الظل
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // أيقونة ثابتة
          onPressed: () {
            Navigator.pop(context); // العودة للخلف
          },
        ),
      ),
      body: Container( // استخدام Container مع تدرج لوني للخلفية بدلاً من الصورة
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // تدرج أزرق سماوي ناعم
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // طبقة داكنة فوق الخلفية لتحسين وضوح النص والبالونات (يمكن تعديلها أو إزالتها)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2), // ظل خفيف جداً
              ),
            ),
            // عرض جميع البالونات النشطة
            // يتم وضعها هنا لتظهر فوق الخلفية وتحت النص المركزي
            ...balloons,
            // النص المركزي في المنتصف
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "استرخِ واستمتع بتفجير البالونات!", // نص باللغة العربية
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo( // استخدام GoogleFonts
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2.0, 2.0), // ثابتة
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // ثابتة
                  // يمكنك إضافة عناصر واجهة مستخدم أخرى هنا إذا أردت
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget يمثل بالوناً واحداً
class Balloon extends StatefulWidget {
  final double startX;
  final double startY;
  final double endY;
  final Duration duration;
  final Color color;
  // دالة تستقبل مفتاح البالون عند النقر عليه
  final Function(Key) onTap;

  // هنا يمكن أن يكون الـ constructor 'const' لأن خصائصه (startX, startY, إلخ) هي 'final'
  // ولكن الكلاس نفسه StatefulWidget لذا لا يمكن استدعائه بـ 'const' من مكان آخر (مثل HomeePage).
  // ولكنه يمكن أن يساعد Flutter على تحسين بناء البالونات داخلياً.
  const Balloon({
    required Key key, // يجب أن يكون لكل بالون مفتاح فريد
    required this.startX,
    required this.startY,
    required this.endY,
    required this.duration,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  _BalloonState createState() => _BalloonState();
}

class _BalloonState extends State<Balloon> with SingleTickerProviderStateMixin {
  // للتحكم في حركة البالون
  late AnimationController _controller;
  // قيمة الأنميشن (موضع البالون)
  late Animation<double> _animation;
  // لتتبع ما إذا كان البالون قد تم تفجيره
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ AnimationController بمدة البالون
    _controller = AnimationController(vsync: this, duration: widget.duration);
    // تعريف الأنميشن لينتقل من startY إلى endY
    _animation = Tween<double>(begin: widget.startY, end: widget.endY).animate(
      // استخدام CurvedAnimation لتأثير حركة سلس (مثلاً، تباطؤ في النهاية)
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addStatusListener((status) {
        // عند اكتمال الأنميشن (وصول البالون لأعلى الشاشة)
        if (status == AnimationStatus.completed && mounted) {
          widget.onTap(widget.key!); // إزالة البالون
        }
      });
    // بدء الأنميشن
    _controller.forward();
  }

  @override
  void dispose() {
    // التخلص من الـ controller عند إزالة الـ widget لتجنب تسرب الذاكرة
    _controller.dispose();
    super.dispose();
  }

  // دالة تُستدعى عند النقر على البالون
  void _handleTap() {
    if (!_isPopped) {
      setState(() {
        _isPopped = true; // وضع علامة على البالون أنه تم تفجيره
      });
      _controller.stop(); // إيقاف الأنميشن فوراً
      // تأخير بسيط لإعطاء تأثير التلاشي قبل إزالة البالون بالكامل
      Future.delayed(const Duration(milliseconds: 100), () { // ثابتة
        if (mounted) {
          widget.onTap(widget.key!); // إزالة البالون من الشاشة
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder لإعادة بناء الـ widget كلما تغيرت قيمة الأنميشن
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.startX, // الموضع الأفقي الثابت
          top: _animation.value, // الموضع الرأسي المتغير بواسطة الأنميشن
          child: AnimatedOpacity(
            // يجعل البالون يتلاشى عند تفجيره
            opacity: _isPopped ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200), // مدة التلاشي ثابتة
            child: GestureDetector(
              onTap: _handleTap, // التعامل مع النقر
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.7), // لون البالون بشفافية
                  shape: BoxShape.circle, // شكل دائري
                  boxShadow: [
                    // ظل لإعطاء تأثير ثلاثي الأبعاد
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(2, 2), // ثابتة
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // إضافة "خيط" للبالون في الأسفل
                    Positioned(
                      bottom: 0,
                      left: 27.5, // 27.5 هو منتصف الـ 60 (عرض البالون) ناقص نصف عرض الخيط (5/2=2.5)
                      child: Container(
                        width: 5,
                        height: 20,
                        color: Colors.grey[400], // لون الخيط
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
