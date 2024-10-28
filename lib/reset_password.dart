import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String id = 'reset_password';
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _selectedLanguage = 'ar'; // Default to Arabic
  String _pass = '';
  @override
  void initState() {
    super.initState();
    _loadSharedPreference();
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }
  Future<void> _loadSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'ar';
         _pass = prefs.getString('pass') ?? '';
    });
  }
  // Example function for updating password (replace with actual logic)
  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      // Logic to change the password goes here, e.g., call an API
        var dvid = await _getId();
        var _newpass = _newPasswordController.text.trim();
         final response = await http.post(
    Uri.parse('https://jerusalemaccounting.yaghco.website/mobile_debt/resetpass.php?device_id=$dvid&pass=$_newpass'),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'pass': _newpass,    
    }),
    
  );
  if (response.statusCode == 201 || response.statusCode == 200) {
  _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
  } else {
    print(response.statusCode );
    throw Exception('Failed');
  }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_selectedLanguage != 'ar' ?'Password changed successfully' :"تمت العملية بنجاح")),
      );
      // Clear the fields after successful update
     
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // Set drawer button color here
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 8, 29, 82), Color.fromARGB(255, 5, 58, 42)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
           _selectedLanguage == 'ar' ? 'القدس لمتابعة الديون' : 'Jerusalem Debts',
          style: GoogleFonts.cairo(
            textStyle: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Directionality(
        textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText:_selectedLanguage != 'ar' ? "Current Password" :"كلمة المرور الحالية"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _selectedLanguage != 'ar' ? 'Please enter your current password' :"الرجاء ادخال كلمة المرور الحالية";
                    }
                    else if(value != _pass)
                    {
                      return _selectedLanguage != 'ar' ?'Password Invalid' :"كلمة المرور غير صحيحة";
                    }
                    // Add additional validation if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: _selectedLanguage != 'ar' ?"New Password" :"كلمة المرور الجديدة"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _selectedLanguage != 'ar' ?'Please enter a new password' :"الرجاء ادخال كلمة المرور الجديدة";
                    } 
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: _selectedLanguage != 'ar' ?"Confirm New Password" :"تأكيد كلمةالمرور"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _selectedLanguage != 'ar' ?'Please confirm your new password' :"الرجاء تأكيد كلمة المرور";
                    } else if (value != _newPasswordController.text) {
                      return _selectedLanguage != 'ar' ?'Passwords do not match' :"كلمة المرور غير متطابقة";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: _buildRoundedButton(
                                  context,
                                  icon: Icons.save,
                                  title: _selectedLanguage == 'ar' ? 'تغيير كلمة المرور' :"Change Password",
                                   onPressed: _updatePassword,
                                ),
                  ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildRoundedButton(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child:  Directionality(
          textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Color(0xFF3A4256),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 6.0,
            shadowColor: Colors.black38,
          ),
          icon: Icon(icon, color: Colors.white, size: 28.0),
          label: Text(
            title,
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
