import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // For user ID and token

// 1. Phobia Data Model
class Phobia {
  final int id;
  final int userId;
  final String phobiaName;
  final String description;
  int progress; // Can be updated
  final DateTime createdAt;
  final DateTime updatedAt;

  Phobia({
    required this.id,
    required this.userId,
    required this.phobiaName,
    required this.description,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Phobia.fromJson(Map<String, dynamic> json) {
    return Phobia(
      id: json['id'],
      userId: json['user_id'],
      phobiaName: json['phobia_name'],
      description: json['description'],
      progress: json['progress'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phobia_name': phobiaName,
      'description': description,
      'progress': progress,
    };
  }
}

class PhobiaPage extends StatefulWidget {
  const PhobiaPage({Key? key}) : super(key: key);

  @override
  _PhobiaPageState createState() => _PhobiaPageState();
}

class _PhobiaPageState extends State<PhobiaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phobiaNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _progress = 0; // Default progress for new phobia

  List<Phobia> _userPhobias = []; // List to store user's phobias from Backend
  bool _isLoading = false; // Loading state for API calls
  bool _isAddingNewPhobia = false; // State to show/hide add phobia form

  // API URL for phobias
  final String _apiUrl = "http://127.0.0.1:8000/api/phobias"; // Use your IP or ngrok
  String? _authToken;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchPhobias();
  }

  @override
  void dispose() {
    _phobiaNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Load user data (token, ID) from SharedPreferences and then fetch phobias
  Future<void> _loadUserDataAndFetchPhobias() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('access_token');
    _currentUserId = prefs.getInt('user_id');

    if (_authToken == null || _currentUserId == null) {
      _showSnackBar('غير مسجل دخول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    await _fetchUserPhobias();
  }

  // Fetch user's phobias from API
  Future<void> _fetchUserPhobias() async {
    if (_authToken == null) return;

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
        final List<dynamic> phobiasData = data['phobias'];
        setState(() {
          _userPhobias = phobiasData
              .map((json) => Phobia.fromJson(json))
              .where((phobia) => phobia.userId == _currentUserId) // Filter by current user
              .toList();
        });
      } else if (response.statusCode == 401) {
        _showSnackBar('غير مصرح لك بالوصول. الرجاء تسجيل الدخول.', Colors.red.shade600);
      } else {
        _showSnackBar('فشل جلب الفوبيا: ${response.statusCode}', Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الاتصال: $e', Colors.red.shade400);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Add a new phobia
  Future<void> _addNewPhobia() async {
    if (_authToken == null || _currentUserId == null) {
      _showSnackBar('الرجاء تسجيل الدخول لإضافة فوبيا.', Colors.orange.shade400);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('الرجاء ملء جميع الحقول المطلوبة.', Colors.orange.shade400);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newPhobia = Phobia(
      id: 0, // ID will be assigned by Backend
      userId: _currentUserId!,
      phobiaName: _phobiaNameController.text.trim(),
      description: _descriptionController.text.trim(),
      progress: _progress,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode(newPhobia.toJson()),
      );

      if (response.statusCode == 201) {
        _showSnackBar('✅ تم إضافة الفوبيا بنجاح!', Colors.green.shade400);
        _phobiaNameController.clear();
        _descriptionController.clear();
        setState(() {
          _progress = 0; // Reset progress
          _isAddingNewPhobia = false; // Hide form
        });
        _fetchUserPhobias(); // Refresh list
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل إضافة الفوبيا: ${response.statusCode}';
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
        _isLoading = false;
      });
    }
  }

  // Update phobia progress
  Future<void> _updatePhobiaProgress(int phobiaId, int newProgress) async {
    if (_authToken == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/$phobiaId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({'progress': newProgress, 'user_id': _currentUserId}), // user_id is required sometimes
      );

      if (response.statusCode == 200) {
        _showSnackBar('✅ تم تحديث التقدم بنجاح!', Colors.green.shade400);
        _fetchUserPhobias(); // Refresh list to reflect changes
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل تحديث التقدم: ${response.statusCode}';
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

  // Delete a phobia
  Future<void> _deletePhobia(int phobiaId) async {
    if (_authToken == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('$_apiUrl/$phobiaId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('🗑️ تم حذف الفوبيا بنجاح!', Colors.grey.shade600);
        _fetchUserPhobias(); // Refresh list
      } else {
        final errorBody = json.decode(response.body);
        String errorMessage = '❌ فشل حذف الفوبيا: ${response.statusCode}';
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

  // Helper for SnackBar
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
          "فهم الفوبيا وإدارتها", // Updated title
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
            onPressed: _isLoading ? null : _fetchUserPhobias,
            tooltip: 'تحديث الفوبيا',
          ),
          IconButton(
            icon: Icon(_isAddingNewPhobia ? Icons.close : Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                _isAddingNewPhobia = !_isAddingNewPhobia;
                if (!_isAddingNewPhobia) {
                  _phobiaNameController.clear();
                  _descriptionController.clear();
                  _progress = 0;
                }
              });
            },
            tooltip: _isAddingNewPhobia ? 'إغلاق نموذج الإضافة' : 'إضافة فوبيا جديدة',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // Soft blue gradient
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
                  "ما هي الفوبيا؟",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "الفوبيا هي نوع من اضطرابات القلق، تتمثل في خوف شديد وغير منطقي من شيء أو موقف معين، يتجاوز الخطر الحقيقي الذي قد يشكله ذلك الشيء أو الموقف.",
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 30),

                // Form to Add New Phobia
                if (_isAddingNewPhobia)
                  Card(
                    margin: const EdgeInsets.only(bottom: 20),
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
                              "إضافة فوبيا جديدة",
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00796B),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _phobiaNameController,
                              decoration: InputDecoration(
                                labelText: "اسم الفوبيا (مثال: رهاب المرتفعات)",
                                labelStyle: GoogleFonts.cairo(),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                prefixIcon: const Icon(Icons.psychology, color: Color(0xFF0288D1)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال اسم الفوبيا.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "وصف الفوبيا",
                                labelStyle: GoogleFonts.cairo(),
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                prefixIcon: const Icon(Icons.description, color: Color(0xFF0288D1)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال وصف الفوبيا.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "التقدم في التغلب على الفوبيا: ${_progress.toInt()}%",
                              style: GoogleFonts.cairo(fontSize: 16, color: Colors.blueGrey.shade700),
                            ),
                            Slider(
                              value: _progress.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: _progress.toString(),
                              onChanged: (double newValue) {
                                setState(() {
                                  _progress = newValue.toInt();
                                });
                              },
                              activeColor: Colors.teal,
                              inactiveColor: Colors.teal.shade100,
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _addNewPhobia,
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Icon(Icons.add, color: Colors.white),
                                label: Text(
                                  _isLoading ? "جارٍ الإضافة..." : "إضافة فوبيا",
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

                // Common Phobias (Static - from original code)
                Text(
                  "أنواع الفوبيا الشائعة (للمعلومات):",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                _buildPhobiaItemStatic(
                  'رهاب المرتفعات (Acrophobia)',
                  'الخوف الشديد وغير المنطقي من الأماكن المرتفعة.',
                  Icons.landscape,
                  Colors.blue.shade700,
                ),
                _buildPhobiaItemStatic(
                  'رهاب الأماكن المغلقة (Claustrophobia)',
                  'الخوف من الأماكن الضيقة أو المزدحمة.',
                  Icons.meeting_room,
                  Colors.purple.shade700,
                ),
                _buildPhobiaItemStatic(
                  'رهاب العناكب (Arachnophobia)',
                  'الخوف الشديد من العناكب.',
                  Icons.bug_report,
                  Colors.green.shade700,
                ),
                _buildPhobiaItemStatic(
                  'رهاب الأماكن المفتوحة (Agoraphobia)',
                  'الخوف من الأماكن أو المواقف التي قد يكون الهروب منها صعباً أو محرجاً.',
                  Icons.public,
                  Colors.red.shade700,
                ),
                _buildPhobiaItemStatic(
                  'رهاب الطيران (Aviophobia)',
                  'الخوف الشديد من السفر جواً.',
                  Icons.airplanemode_active,
                  Colors.orange.shade700,
                ),
                const SizedBox(height: 30),

                // My Phobias (Dynamic - from Backend)
                Text(
                  "فوبياتي (المسجلة):",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                _isLoading && _userPhobias.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                    : _userPhobias.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد فوبيا مسجلة بعد. استخدم زر الإضافة لتسجيل فوبيا.',
                              style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            children: _userPhobias.map((phobia) {
                              return _buildUserPhobiaCard(phobia);
                            }).toList(),
                          ),

                const SizedBox(height: 30),

                // Coping Strategies (Static - from original code)
                Text(
                  "طرق التعامل مع الفوبيا:",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCopingStrategy(
                  Icons.psychology,
                  "العلاج السلوكي المعرفي (CBT)",
                  "يساعد على تغيير أنماط التفكير السلبية والسلوكيات المرتبطة بالخوف.",
                  Colors.indigo.shade700,
                ),
                _buildCopingStrategy(
                  Icons.exposure,
                  "العلاج بالتعرض (Exposure Therapy)",
                  "التعرض التدريجي للمخاوف في بيئة آمنة للمساعدة في تقليل القلق.",
                  Colors.brown.shade700,
                ),
                _buildCopingStrategy(
                  Icons.medication,
                  "الأدوية",
                  "قد يصف الطبيب أدوية معينة للتحكم في أعراض القلق المصاحبة للفوبيا.",
                  Colors.blueGrey.shade700,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for static Phobia items (from original code)
  Widget _buildPhobiaItemStatic(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for User's Phobia Cards (Dynamic - from Backend)
  Widget _buildUserPhobiaCard(Phobia phobia) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                Expanded(
                  child: Text(
                    phobia.phobiaName,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(phobia.id),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              phobia.description,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "التقدم: ${phobia.progress.toInt()}%",
                  style: GoogleFonts.cairo(fontSize: 15, color: Colors.blueGrey.shade700),
                ),
                Expanded(
                  child: Slider(
                    value: phobia.progress.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: phobia.progress.toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        phobia.progress = newValue.toInt(); // Update local state immediately
                      });
                      _updatePhobiaProgress(phobia.id, newValue.toInt()); // Call API to update
                    },
                    activeColor: Colors.deepPurple,
                    inactiveColor: Colors.deepPurple.shade100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'آخر تحديث: ${phobia.updatedAt.toLocal().toString().split(' ')[0]}',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Coping Strategies (Static)
  Widget _buildCopingStrategy(IconData icon, String title, String description, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: color),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Confirm delete dialog
  void _confirmDelete(int phobiaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الحذف", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Text("هل أنت متأكد أنك تريد حذف هذه الفوبيا؟", style: GoogleFonts.cairo()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey.shade700)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePhobia(phobiaId);
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
