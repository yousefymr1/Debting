import 'package:alquds_debting/admin_screen.dart';
import 'package:alquds_debting/edit_customer.dart';
import 'package:alquds_debting/kashf_hesab.dart';
import 'package:alquds_debting/reset_password.dart';
import 'package:alquds_debting/settings.dart';
import 'package:flutter/material.dart';
import 'package:alquds_debting/welcome_page.dart';
import 'package:alquds_debting/first_page.dart';
import 'package:alquds_debting/add_customer.dart';
import 'package:alquds_debting/qabd.dart';
import 'package:alquds_debting/report_sanadat.dart';
import 'package:alquds_debting/report_mogmal_zemam.dart';
void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     
     
    return MaterialApp(
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      debugShowCheckedModeBanner: false,
      routes: {
        FirstPage.id: (context) => FirstPage(),
       WelcomeScreen.id: (context) => WelcomeScreen(),
         AddCustomer.id: (context) => AddCustomer(),
                AddQabd.id: (context) => AddQabd(),
                  KashfHesab.id: (context) => KashfHesab(),
                    SanadatReport.id: (context) => SanadatReport(),
                     ZemamReport.id: (context) => ZemamReport(),
                     AdminScreen.id: (context) => AdminScreen(),
                            EditCustomer.id: (context) => EditCustomer(),
                                Setting.id: (context) => Setting(),
                                   ChangePasswordPage.id: (context) => ChangePasswordPage(),
                            
      },
    );
  }
}
