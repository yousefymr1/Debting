import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

final TextEditingController _controller1 = TextEditingController();
final TextEditingController _controller2 = TextEditingController();
   String _selectedLanguage = 'ar'; // Default to Arabic
Future<String> createCustomer(String c_name, String c_phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? company_id = prefs.getString("company_id");

  final response = await http.post(
    Uri.parse(
      'https://jerusalemaccounting.yaghco.website/mobile_debt/add_customer.php?company_id=$company_id&c_name=$c_name&c_phone=$c_phone',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'company_id': company_id ?? "0",
      'c_name': c_name,
      'c_phone': c_phone,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    _controller2.text = "";
    _controller1.text = "";

    // Show success toast
    Fluttertoast.showToast(
      msg: _selectedLanguage == 'ar' ? "تم إضافة الزبون بنجاح" : "Added Successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    return "Customer created successfully";
  } else {
    throw Exception('Failed to create customer.');
  }
}

class AddCustomer extends StatefulWidget {
  static const String id = 'add_customer';
  AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

   void initState() {
    super.initState();
    _loadSharedPreference();
  }

  Future<void> _loadSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'ar';
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
          _selectedLanguage == 'ar' ?  "إضافة زبون جديد" : 'Add Customer',
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
            TextField(
              controller: _controller1,
             // textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText:_selectedLanguage == 'ar' ?  "اسم الزبون" :"Customer Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person),
                contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller2,
            //  textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText:_selectedLanguage == 'ar' ?  "رقم الهاتف" : "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.phone),
                contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 40),
            _buildRoundedButton(
              context,
              icon: Icons.save,
              title: _selectedLanguage == 'ar' ? 'حفظ' :"Save",
              onPressed: () {
                if (_controller1.text.trim() != "") {
                  createCustomer(_controller1.text.trim(), _controller2.text.trim())
                      .then((_) {
                    // Show success toast after customer is created
                    print("object");
                    Fluttertoast.showToast(
                      msg: _selectedLanguage == 'ar' ?  "تم إضافة الزبون بنجاح" :"Done",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }).catchError((e) {
                    Fluttertoast.showToast(
                      msg: _selectedLanguage == 'ar' ? "حدث خطأ أثناء إضافة الزبون":"something went wrong",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                } else {
                  _showDialog(context,_selectedLanguage == 'ar' ?  "الرجاء ادخال اسم الزبون" :"Phease Enter Customer Name");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: GoogleFonts.cairo(textStyle: TextStyle(fontSize: 16)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
              _selectedLanguage == 'ar' ?   'حسنا' :"OK",
                style: GoogleFonts.cairo(textStyle: TextStyle(color: Color(0xff34568B))),
              ),
            ),
          ],
        );
      },
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
