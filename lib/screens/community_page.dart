import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // استيراد Google Fonts
import 'package:http/http.dart' as http; // استيراد حزمة HTTP
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد SharedPreferences

// نموذج بيانات المستخدم (يمكن وضعه في ملف مشترك لاحقاً)
class AppUser {
  final int id;
  final String name;
  final String email;
  final bool active;
  final List<String> roles;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.active,
    required this.roles,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      active: json['active'] == 1 || json['active'] == true,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => role['name'] as String)
              .toList() ??
          [],
    );
  }
}

// نموذج بيانات رسالة المجتمع
class CommunityMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime sentAt;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  // معلومات المرسل والمستقبل (محملة من الـ Backend)
  final AppUser? sender;
  final AppUser? receiver;

  CommunityMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sentAt,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
  });

  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    return CommunityMessage(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      sentAt: DateTime.parse(json['sent_at']),
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      sender: json['sender'] != null ? AppUser.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? AppUser.fromJson(json['receiver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'sent_at': sentAt.toIso8601String(), // تحويل DateTime إلى سلسلة ISO 8601
      'is_read': isRead,
    };
  }
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _receiverIdController = TextEditingController(); // لإدخال ID المستلم
  final _formKey = GlobalKey<FormState>(); // مفتاح لنموذج إرسال الرسائل

  List<CommunityMessage> _communityMessages = []; // قائمة الرسائل المحملة
  bool _isLoading = false; // حالة التحميل لـ Fetch
  bool _isSending = false; // حالة الإرسال لزر الإرسال

  String? _authToken;
  int? _currentUserId;
  String? _currentUserName; // لتمييز المستخدم الحالي في عرض الرسائل
  final String _apiUrl = "http://127.0.0.1:8000/api"; // عنوان الـ API الأساسي

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _receiverIdController.dispose();
    super.dispose();
  }

  // تحميل بيانات المستخدم (التوكن، الـ ID، الاسم) ثم جلب الرسائل
  Future<void> _loadUserDataAndFetchMessages() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('access_token');
    _currentUserId = prefs.getInt('user_id');
    _currentUserName = prefs.getString('user_name'); // جلب اسم المستخدم الحالي

    if (_authToken == null || _currentUserId == null) {
      _showSnackBar('غير مسجل دخول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    await _fetchCommunityMessages();
  }

  // جلب رسائل المجتمع من الـ API
  Future<void> _fetchCommunityMessages() async {
    if (_authToken == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$_apiUrl/community_messages'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> messagesData = data['community_messages'];

        // تصفية الرسائل التي يكون فيها المستخدم الحالي هو المرسل أو المستقبل
        List<CommunityMessage> fetchedMessages = messagesData
            .map((json) => CommunityMessage.fromJson(json))
            .where((msg) => msg.senderId == _currentUserId || msg.receiverId == _currentUserId)
            .toList();

        // ترتيب الرسائل حسب وقت الإرسال لعرضها كتسلسل محادثة (الأقدم أولاً)
        fetchedMessages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

        setState(() {
          _communityMessages = fetchedMessages;
        });
      } else if (response.statusCode == 401) {
        _showSnackBar('غير مصرح لك بالوصول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      } else {
        _showSnackBar('فشل جلب الرسائل: ${response.statusCode}', Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الاتصال: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // إرسال رسالة مجتمعية جديدة
  Future<void> _sendCommunityMessage() async {
    if (_authToken == null || _currentUserId == null) {
      _showSnackBar('الرجاء تسجيل الدخول لإرسال رسالة.', Colors.orange.shade400);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return; // لا ترسل إذا كان النموذج غير صالح
    }

    final int? receiverId = int.tryParse(_receiverIdController.text.trim());
    if (receiverId == null || receiverId == _currentUserId) { // لا يمكن إرسال رسالة لنفسك
      _showSnackBar('الرجاء إدخال معرف مستلم صالح ومختلف عن معرفك.', Colors.orange.shade400);
      return;
    }

    setState(() {
      _isSending = true;
    });

    final newMessage = CommunityMessage(
      id: 0, // الـ ID سيتم تعيينه بواسطة الـ Backend
      senderId: _currentUserId!,
      receiverId: receiverId,
      message: _messageController.text.trim(),
      sentAt: DateTime.now(),
      isRead: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/community_messages'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode(newMessage.toJson()),
      );

      if (response.statusCode == 201) {
        _showSnackBar('✅ تم إرسال الرسالة بنجاح!', Colors.green.shade400);
        _messageController.clear();
        _fetchCommunityMessages(); // تحديث قائمة الرسائل بعد الإرسال
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل إرسال الرسالة: ${response.statusCode}';
        if (errorBody['messages'] != null) {
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
        _isSending = false;
      });
    }
  }

  // دالة مساعدة لعرض SnackBar
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

  // بناء فقاعة الرسالة
  Widget _buildMessageBubble(CommunityMessage message) {
    bool isMe = message.senderId == _currentUserId;
    String senderDisplayName = message.sender?.name ?? "مستخدم غير معروف";
    String receiverDisplayName = message.receiver?.name ?? "مستخدم غير معروف";

    // إذا كنت أنت المرسل، ستظهر "إلى: [اسم المستلم]"
    // إذا كان شخص آخر هو المرسل، ستظهر "من: [اسم المرسل]"
    String headerText = isMe ? "إلى: $receiverDisplayName" : "من: $senderDisplayName";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isMe ? Colors.blue.shade800 : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.message,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${message.sentAt.toLocal().hour}:${message.sentAt.toLocal().minute.toString().padLeft(2, '0')} - ${message.sentAt.toLocal().day}/${message.sentAt.toLocal().month}',
              style: GoogleFonts.cairo(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "تواصل مع الآخرين",
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
            onPressed: _isLoading || _isSending ? null : _fetchCommunityMessages,
            tooltip: 'تحديث الرسائل',
          ),
        ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "تواصل مع المستخدمين الآخرين عبر الرسائل المباشرة. يمكنك رؤية رسائلك المرسلة والمستقبلة هنا.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // قائمة الرسائل (واجهة الدردشة)
              Expanded(
                child: _isLoading && _communityMessages.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                    : _communityMessages.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'لا توجد محادثات بعد. ابدأ بإرسال رسالة!',
                                style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            reverse: false, // الأقدم أولاً، الأحدث في الأسفل
                            padding: const EdgeInsets.only(bottom: 16.0),
                            itemCount: _communityMessages.length,
                            itemBuilder: (context, index) {
                              final message = _communityMessages[index];
                              return _buildMessageBubble(message);
                            },
                          ),
              ),
              const Divider(height: 1, color: Colors.grey),
              // منطقة إدخال الرسالة
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      // حقل إدخال معرف المستلم
                      SizedBox(
                        width: 90, // عرض ثابت لمعرف المستلم
                        child: TextFormField(
                          controller: _receiverIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "ID المستلم",
                            hintStyle: GoogleFonts.cairo(fontSize: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ID مطلوب';
                            }
                            if (int.tryParse(value) == null) {
                              return 'رقم صالح';
                            }
                            return null;
                          },
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // حقل إدخال الرسالة
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "اكتب رسالة...",
                            hintStyle: GoogleFonts.cairo(fontSize: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرسالة لا يمكن أن تكون فارغة';
                            }
                            return null;
                          },
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // زر الإرسال
                      _isSending
                          ? const CircularProgressIndicator()
                          : FloatingActionButton(
                              onPressed: _sendCommunityMessage,
                              backgroundColor: const Color(0xFF0288D1),
                              mini: true, // زر صغير
                              child: const Icon(Icons.send, color: Colors.white),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
