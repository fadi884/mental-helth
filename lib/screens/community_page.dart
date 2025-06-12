import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "تواصل مع الآخرين",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.lightBlue.shade100, // Consistent background
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "شارك قصتك، اطرح أسئلتك، واستفد من تجارب مجتمعنا.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0, // Make cards square
                      children: [
                        _buildCommunityCard(
                          context,
                          'شارك تجربتك',
                          'اكتب عن رحلتك وتحدياتك وإنجازاتك.',
                          Icons.edit_note,
                          Colors.teal.shade300,
                          () {
                            // TODO: Navigate to a page for sharing experiences (e.g., a form)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('صفحة مشاركة التجربة قيد الإنشاء!')),
                            );
                          },
                        ),
                        _buildCommunityCard(
                          context,
                          'اسأل المجتمع',
                          'اطرح أسئلتك واحصل على الدعم والنصائح.',
                          Icons.forum, // **تم تصحيح الخطأ هنا (Icons.Youtube كانت هنا)**
                          Colors.blue.shade300,
                          () {
                            // TODO: Navigate to a Q&A forum or discussion board
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('صفحة الأسئلة والأجوبة قيد الإنشاء!')),
                            );
                          },
                        ),
                        _buildCommunityCard(
                          context,
                          'اكتشف القصص',
                          'اقرأ تجارب الآخرين واستلهم منها.',
                          Icons.book,
                          Colors.purple.shade300,
                          () {
                            // TODO: Navigate to a page displaying shared stories
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('صفحة اكتشاف القصص قيد الإنشاء!')),
                            );
                          },
                        ),
                        _buildCommunityCard(
                          context,
                          'شاهد فيديوهات',
                          'شاهد نصائح وتجارب ملهمة عبر الفيديو.',
                          Icons.play_circle_fill, // هذا الأيقونة للفيديوهات صحيحة
                          Colors.red.shade300,
                          () {
                            // TODO: Navigate to a page with video content
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('صفحة الفيديوهات قيد الإنشاء!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.9),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}