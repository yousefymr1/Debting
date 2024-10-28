import 'dart:convert';
import 'dart:io';
import 'package:alquds_debting/welcome_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
var Main_Color = Color.fromRGBO(58, 66, 86, 1.0);
var active = "0";
class AdminScreen extends StatefulWidget {
    static const String id = 'admin_screen';
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _selectedLanguage = 'ar'; // Default to Arabic

 @override
  void initState() {
    super.initState();
    _loadSharedPreference();
  }

Future<void> _loadSharedPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _selectedLanguage = prefs.getString('language') ?? 'ar';  // Default to Arabic if no preference is set
  });
}
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    //print(arguments['a_code']);
    active = arguments['active'];

    return Container(
      color: Main_Color,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldState,
    
        body: Directionality(
      textDirection:_selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
               _selectedLanguage == 'ar' ?   "اضافة مستخدم" :"Create Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(    _selectedLanguage == 'ar' ?   "اسم المستخدم":"UsarName",
                      
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: nameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff34568B), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: _selectedLanguage == 'ar' ?   "أسم المستخدم" :"UserName",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLanguage == 'ar' ?   "كلمه المرور": "Password",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: passwordController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff34568B), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: _selectedLanguage == 'ar' ?   "كلمه المرور" :"Passwors",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                    _selectedLanguage == 'ar' ?     "تأكيد كلمه المرور" :"Confirm password",
                    
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    controller: repasswordController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff34568B), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText:  _selectedLanguage == 'ar' ?     "تأكيد كلمه المرور" :"Confirm password",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                    _selectedLanguage == 'ar' ?    "رقم الشركة" :"Company Id",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    controller: companyIDController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff34568B), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText:   _selectedLanguage == 'ar' ?    "رقم الشركة" :"Company Id",
                    ),
                  ),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLanguage == 'ar' ?    "اسم الشركة" :"Company Name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
              
                    controller: companyNAMEController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff34568B), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText:      _selectedLanguage == 'ar' ?    "اسم الشركة" :"Company Name",
                    ),
                  ),
                ),
              ),
            Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                    _selectedLanguage == 'ar' ?   "الرابط" :"Link",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                  
                    controller: msg_linkController,
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff34568B), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: _selectedLanguage == 'ar' ? "الرابط" :"Link",
                    ),
                  ),
                ),
              ),
            
           
              Padding(
                padding: const EdgeInsets.only(
                    right: 25, left: 25, top: 35, bottom: 20),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  minWidth: double.infinity,
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  textColor: Colors.white,
                  child: Text(
                  _selectedLanguage == 'ar' ?   "اضافة مستخدم" :"Save",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(child: CircularProgressIndicator())),
                        );
                      },
                    );
                    send();
                  },
                ),
              ),
            ],
          )),
        ),
      )),
    );
  }

  bool orders = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController companyIDController = TextEditingController();
   TextEditingController companyNAMEController = TextEditingController();
  TextEditingController salesmanIDController = TextEditingController();
  TextEditingController msg_linkController = TextEditingController();

  send() async {
    if (companyIDController.text == '' ||
        passwordController.text == '' ||
        repasswordController.text == '' ||
       
        nameController.text == '') {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(   _selectedLanguage == 'ar' ? "الرجاء تعبئه جمبع الفراغات" :"Please enter all information"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسنا',
                  style: TextStyle(color: Color(0xff34568B)),
                ),
              ),
            ],
          );
        },
      );
    } else if (passwordController.text != repasswordController.text) {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(   _selectedLanguage == 'ar' ? "كلمه المرور غير متطابقه" :"Password invalid"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسنا',
                  style: TextStyle(color: Color(0xff34568B)),
                ),
              ),
            ],
          );
        },
      );
    } else {
      String? deviceId = await _getId();
      var url = 'https://jerusalemaccounting.yaghco.website/mobile_debt/add_user.php';
      var headers = {"Accept": "application/json"};
      final response = await http.post(Uri.parse(url),
          body: {
            'password': passwordController.text,
            'device_id': deviceId.toString(),
            'name': nameController.text,
               'company_name': companyNAMEController.text,
            'company_id': companyIDController.text,
              'msg_link': msg_linkController.text,
              'active': active,
            
          },
          headers: headers);
//print("object");
      //var data = jsonDecode(response.body);
      //print(data.toString());
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
      //  Fluttertoast.showToast(msg: "تم اضافه المستخدم بنجاح");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      } 
      else {
        Navigator.of(context, rootNavigator: true).pop();
        print("failed");
      }
    }
  }


  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
