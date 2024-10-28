import 'package:alquds_debting/admin_screen.dart';
import 'package:alquds_debting/first_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // For localization support

import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

final TextEditingController _controller1 = TextEditingController();
final TextEditingController _controller2 = TextEditingController();



class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  String _selectedLanguage = 'ar'; // Default to Arabic

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference(); // Load saved language preference
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.white, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'ar';
    });
  }

  Future<void> _saveLanguagePreference(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
  List _loadedPhotos = [];

  Future<void> _fetchData() async {
    var dvid = await _getId();
    var apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_user.php?allow=yes&device_id=$dvid';
    
    HttpClient client = HttpClient();
    client.autoUncompress = true;
    
    final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();
    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content) ?? [];
    
    setState(() {
      _loadedPhotos = data;
    });
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
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _header(),
            _inputFields(),
          
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          _selectedLanguage == 'ar' ? 'القدس لمتابعة الديون' : 'Jerusalem Debts',
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _inputFields() {
    return Expanded(
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/a.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  _selectedLanguage == 'ar' ? "اسم المستخدم" : "Username", 
                  Icons.person, _controller1, false),
              const SizedBox(height: 20),
              _buildTextField(
                  _selectedLanguage == 'ar' ? "كلمة المرور" : "Password", 
                  Icons.lock, _controller2, true),
              const SizedBox(height: 20),
              _buildLoginButton(),
                _languageSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon, TextEditingController controller, bool obscureText) {
    return TextField(
      controller: controller,
      textAlign: _selectedLanguage == 'ar' ? TextAlign.right : TextAlign.left,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
      ),
    );
  }

  Widget _buildLoginButton() {
    return _buildRoundedButton(
      context,
      icon: Icons.login,
      title: _selectedLanguage == 'ar' ? 'تسجيل دخول' : 'Login',
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await _fetchData();

        if (_controller1.text == "app" && _controller2.text == "store") {
          await prefs.setString('company_id', '1');
          Navigator.pushNamed(context, FirstPage.id);
        } else if (_controller1.text == "98" && _controller2.text == "yagh2255") {
          Navigator.pushNamed(context, AdminScreen.id, arguments: {'active': "1"});
        } else if (_controller1.text == "100" && _controller2.text == "123456789") {
          Navigator.pushNamed(context, AdminScreen.id, arguments: {'active': "0"});
        } else if (_loadedPhotos.isNotEmpty) {
          if (_controller1.text == _loadedPhotos[0]['name'] &&
              _controller2.text == _loadedPhotos[0]['password']) {
                if(_loadedPhotos[0]["activation_end"].toString() != "0000-00-00"){
                  var itemDate = DateTime.parse(_loadedPhotos[0]["activation_end"].toString());
                DateTime itemDate2 =DateTime.parse("${itemDate.year.toString()}-${itemDate.month.toString().padLeft(2,'0')}-${itemDate.day.toString().padLeft(2,'0')}");
    
   if(itemDate2.compareTo(DateTime.now()) >= 0) {
    
         
            await prefs.setString('company_id', _loadedPhotos[0]['company_id']);
            await prefs.setString('company_name', _loadedPhotos[0]['company_name']);
            await prefs.setString('msg_link', _loadedPhotos[0]['msg_link']);
            await prefs.setString('activation_end', _loadedPhotos[0]['activation_end']);
             await prefs.setString('activation_date', _loadedPhotos[0]['activation_date']);
            await prefs.setString('pass', _loadedPhotos[0]['password']);
            setState(() {
                _controller1.text = "";
            _controller2.text = "";
            });
          
            Navigator.pushNamed(context, FirstPage.id);
                }
                else
                {
                    showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:_selectedLanguage == 'ar' ? const Text( 'الرجاء تجديد الاشتراك') : const Text( 'Please renew your subscription.'), 
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: _selectedLanguage == 'ar' ? const Text(
                      'حسنا') : const Text(
                      'ok'
                       ) ,
                 
                    ),
                  
                ],
              );
            },
          );
                }
                }
                 else
                {
                    showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:_selectedLanguage == 'ar' ? const Text( 'الرجاء تجديد الاشتراك') : const Text( 'Please renew your subscription.'), 
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: _selectedLanguage == 'ar' ? const Text(
                      'حسنا') : const Text(
                      'ok'
                       ) ,
                 
                    ),
                ],
              );
            },
          );
                }
          
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:_selectedLanguage == 'ar' ? const Text('الرجاء التأكد من اسم المستخدم وكلمة المرور') : const Text('Please check your username and password.'),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: _selectedLanguage == 'ar' ? const Text(
                      'حسنا') : const Text(
                      'ok'
                       ) ,
                  ),
                ],
              );
            },
          );
        }
        }
      },
    
     
    );
  }

  Widget _buildRoundedButton(BuildContext context, {required IconData icon, required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Directionality(
        textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 45, 65), 
                Color.fromARGB(255, 14, 165, 92),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.transparent,
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
      ),
    );
  }

  Widget _languageSelector() {
  return Padding(
    padding: const EdgeInsets.all(16.0),  // Add padding for better visibility
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,  // Background color for better contrast
        borderRadius: BorderRadius.circular(8),  // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,  // Soft shadow effect
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blueAccent, width: 2),  // Border to highlight the dropdown
      ),
      child: DropdownButton<String>(
        value: _selectedLanguage,
        icon: Icon(Icons.language, color: Colors.blueAccent),  // Add an icon for language
        isExpanded: true,  // Make the dropdown take the full width of the container
        underline: SizedBox.shrink(),  // Remove the default underline
        style: TextStyle(
          fontSize: 18,  // Increase font size for better readability
          color: Colors.black,  // Text color
        ),
        dropdownColor: Colors.white,  // Dropdown background color
        items: [
          DropdownMenuItem(
            value: 'ar',
            child: Text('العربية'),
          ),
          DropdownMenuItem(
            value: 'en',
            child: Text('English'),
          ),
        ],
        onChanged: (String? newLanguage) {
          setState(() {
            _selectedLanguage = newLanguage!;
            _saveLanguagePreference(_selectedLanguage);  // Save user preference
          });
        },
      ),
    ),
  );
}

}
