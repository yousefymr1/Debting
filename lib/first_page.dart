import 'package:alquds_debting/settings.dart';
import 'package:alquds_debting/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alquds_debting/add_customer.dart';
import 'package:alquds_debting/qabd.dart';
import 'package:alquds_debting/kashf_hesab.dart';
import 'package:alquds_debting/report_mogmal_zemam.dart';
import 'package:alquds_debting/report_sanadat.dart';
import 'package:url_launcher/url_launcher.dart';
class FirstPage extends StatefulWidget {
  static const String id = 'first_page';
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  String _selectedLanguage = 'ar'; // Default to Arabic
  @override
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
      drawerScrimColor : Colors.white,
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
      drawer: Drawer(
  child: Column(
    children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 45, 65), // Bright blue
              Color.fromARGB(255, 14, 165, 92), // Bright green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
                  width: double.infinity, // Ensures the color fills the entire width

          child: Column(
            children: [
              Text(
                _selectedLanguage == 'ar' ? 'القائمة' : 'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Image.asset(
                "assets/a.png",
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(_selectedLanguage == 'ar' ? 'الإعدادات' : 'Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Setting.id);
              },
            ),
             ListTile(
              leading: Icon(Icons.contact_page),
              title: Text(_selectedLanguage == 'ar' ? 'تواصل معنا' : 'Contact Us'),
              onTap: () async {
                if (!await launchUrl(Uri.parse('https://yaghm.com/yaghco/contact_us.php'))) {
    throw Exception('Could not launch https://yaghm.com/yaghco/contact_us.php');
  }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(_selectedLanguage == 'ar' ? 'تسجيل الخروج' : 'Sign Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'assets/logo3.jpeg', // Replace with your image path
          //width: 100, // Set width as per your requirement
        ),
      ),
    ],
  ),
),

      body: SingleChildScrollView(
        child: Directionality(
          textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
               
                _buildRoundedButton(
                  context,
                  icon: Icons.person_add,
                  title:   _selectedLanguage == 'ar' ? 'إضافة زبون' :'Add Customer',
                  onPressed: () => Navigator.pushNamed(context, AddCustomer.id),
                ),
                _buildRoundedButton(
                  context,
                  icon: Icons.edit,
                  title:_selectedLanguage == 'ar' ? 'تسجيل دين' : 'Add Debt',
                  onPressed: () => Navigator.pushNamed(context, AddQabd.id, arguments: {'a_code': "1"}),
                ),
                _buildRoundedButton(
                  context,
                  icon: Icons.payment,
                  title:_selectedLanguage == 'ar' ? 'تسجيل دفعة' : 'Add Payment',
                  onPressed: () => Navigator.pushNamed(context, AddQabd.id, arguments: {'a_code': "2"}),
                ),
                _buildRoundedButton(
                  context,
                  icon: Icons.account_balance_wallet,
                  title:_selectedLanguage == 'ar' ? 'كشف حساب' : 'account statement',
                  onPressed: () => Navigator.pushNamed(context, KashfHesab.id),
                ),
                _buildRoundedButton(
                  context,
                  icon: Icons.account_balance,
                  title: _selectedLanguage == 'ar' ?'مجمل الذمم' : 'Total accounts receivable',
                  onPressed: () => Navigator.pushNamed(context, ZemamReport.id),
                ),
                _buildRoundedButton(
                  context,
                  icon: Icons.attach_money,
                  title:_selectedLanguage == 'ar' ? 'مجمل الديون': 'Debts Report',
                  onPressed: () => Navigator.pushNamed(context, SanadatReport.id, arguments: {'a_code': "1"}),
                ),
                _buildRoundedButton(
                  context,
                  icon: Icons.money_off,
                  title:_selectedLanguage == 'ar' ? 'مجمل الدفعات' : 'Payments Report',
                  onPressed: () => Navigator.pushNamed(context, SanadatReport.id, arguments: {'a_code': "2"}),
                ),
              ],
            ),
          ),
        ),
      ),
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
                Color.fromARGB(255, 1, 45, 65), // Bright blue
                Color.fromARGB(255, 14, 165, 92), // Bright green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.transparent, // Set to transparent to show gradient
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
  
}
