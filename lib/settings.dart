import 'dart:convert';
import 'package:alquds_debting/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

   String _selectedLanguage = 'ar'; // Default to Arabic

   String _activation_end ="01-01-2024"; 
     String _activation_date ="01-01-2024"; 

class Setting extends StatefulWidget {
  static const String id = 'settings';
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

   void initState() {
    super.initState();
    _loadSharedPreference();
  }

  Future<void> _loadSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'ar';
      _activation_end = prefs.getString('activation_end') ?? '01-01-2024';
      _activation_date = prefs.getString('activation_date') ?? '01-01-2024';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            textStyle: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _header(context),
              _inputField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text(
          _selectedLanguage == 'ar' ?  "إعدادات الحساب" : 'Settings',
          style: GoogleFonts.cairo(
            textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3A4256)),
          ),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Directionality(
          textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                Flexible(
                  child: Text(
                            _selectedLanguage == 'ar' ?   '  بدء الإشتراك:' :"  Subscription start: ",
                            textAlign:  _selectedLanguage == 'ar' ?   TextAlign.right : TextAlign.left,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                ),
                        SizedBox(width: 10),
                         Flexible(
                           child: Text(
                            _activation_date,
                            textAlign:  _selectedLanguage == 'ar' ?   TextAlign.right : TextAlign.left,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                   ),
                         ),
              ],
               
            ),
                    SizedBox(height: 40),
                     Row(
              children: [
                Flexible(
                  child: Text(
                            _selectedLanguage == 'ar' ?   '  انتهاء الإشتراك:' :"  Subscription expiration: ",
                            textAlign:  _selectedLanguage == 'ar' ?   TextAlign.right : TextAlign.left,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                ),
                        SizedBox(width: 10),
                         Flexible(
                           child: Text(
                            _activation_end,
                            textAlign:  _selectedLanguage == 'ar' ?   TextAlign.right : TextAlign.left,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                   ),
                         ),
              ],
               
            ),
                    SizedBox(height: 40),
            _buildRoundedButton(
              context,
              icon: Icons.save,
              title: _selectedLanguage == 'ar' ? 'تغيير كلمة المرور' :"Change Password",
              onPressed: () {
               Navigator.pushNamed(context, ChangePasswordPage.id);
                
              },
            ),
          ],
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
