import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "الإعدادات",
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تفضيلات التطبيق",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSettingsTile(
                  context,
                  Icons.language,
                  "اللغة",
                  "العربية (اللغة الافتراضية)",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تغيير اللغة قيد الإنشاء!',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  Icons.notifications,
                  "الإشعارات",
                  "تلقي إشعارات تذكيرية يومية",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'إدارة الإشعارات قيد الإنشاء!',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  Icons.lock,
                  "الخصوصية والأمان",
                  "مراجعة سياسة الخصوصية وحماية البيانات",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'صفحة الخصوصية قيد الإنشاء!',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  Icons.info_outline,
                  "حول التطبيق",
                  "معلومات عن التطبيق والإصدار",
                  () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'تطبيق الصحة النفسية',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 جميع الحقوق محفوظة.',
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            'هذا التطبيق مصمم لمساعدتك في رحلتك نحو الصحة النفسية والرفاهية.',
                            style: GoogleFonts.cairo(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  Icons.star,
                  "قيم التطبيق",
                  "ساعدنا في تحسين التطبيق بتقييمك",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'صفحة التقييم قيد الإنشاء!',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  },
                ),
                 _buildSettingsTile(
                  context,
                  Icons.help_outline,
                  "المساعدة والدعم",
                  "تواصل معنا للحصول على المساعدة",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'صفحة المساعدة قيد الإنشاء!',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "نسخة 1.0.0",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(icon, size: 30, color: Colors.blue.shade700),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade900,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: Colors.blueGrey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
