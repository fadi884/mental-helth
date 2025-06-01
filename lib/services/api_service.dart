import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://127.0.0.1:8000/api/questionnaires"; // تأكد من صحة رابط API

  /// دالة لإرسال الاستبيان إلى السيرفر
  Future<bool> sendQuestionnaire(Map<String, dynamic> questionnaireData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(questionnaireData),
      );

      if (response.statusCode == 201) {
        print("✅ تم إرسال الاستبيان بنجاح!");
        return true;
      } else {
        print("❌ خطأ أثناء إرسال الاستبيان: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ خطأ غير متوقع: $e");
      return false;
    }
  }

  /// دالة لجلب جميع الاستبيانات من السيرفر
  Future<List<dynamic>> getQuestionnaires() async {
    try {
      final response = await http.get(Uri.parse(baseUrl), headers: {
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ خطأ في جلب الاستبيانات: ${response.body}");
        return [];
      }
    } catch (e) {
      print("⚠️ خطأ غير متوقع: $e");
      return [];
    }
  }

  /// دالة لجلب استبيان معين باستخدام ID
  Future<Map<String, dynamic>?> getQuestionnaireById(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"), headers: {
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ الاستبيان غير موجود: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ خطأ غير متوقع: $e");
      return null;
    }
  }

  /// دالة لتحديث استبيان معين
  Future<bool> updateQuestionnaire(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print("✅ تم تحديث الاستبيان بنجاح!");
        return true;
      } else {
        print("❌ خطأ أثناء التحديث: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ خطأ غير متوقع: $e");
      return false;
    }
  }

  /// دالة لحذف استبيان معين
  Future<bool> deleteQuestionnaire(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"), headers: {
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("✅ تم حذف الاستبيان بنجاح!");
        return true;
      } else {
        print("❌ خطأ أثناء الحذف: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ خطأ غير متوقع: $e");
      return false;
    }
  }
}
