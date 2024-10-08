import 'package:alquds_debting/kashf_hesab.dart';
import 'package:alquds_debting/report_mogmal_zemam.dart';
import 'package:alquds_debting/report_sanadat.dart';
import 'package:alquds_debting/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:alquds_debting/add_customer.dart';
import 'package:alquds_debting/qabd.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FirstPage extends StatelessWidget {
  static const String id = 'first_page';
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
             elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
 centerTitle: true,
        title:  const Text('القدس لمتابعة الديون' ,textAlign: TextAlign.right,
        style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RoundedButton(
                 icon: Icons.arrow_back,
                  title: 'إضافة زبون',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () async {
    

                       Navigator.pushNamed(context, AddCustomer.id);
                  }),
              RoundedButton(
                  icon: Icons.arrow_back,
                  title: 'تسجيل دين',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                    Navigator.pushNamed(context, AddQabd.id, arguments: {
                                      'a_code': "1"
                                    },);
                  }),
                  RoundedButton(
                      icon: Icons.arrow_back,
                  title: 'تسجيل دفعة',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                     Navigator.pushNamed(context, AddQabd.id, arguments: {
                                      'a_code': "2"
                                    },);
                  }),
             RoundedButton(
                icon: Icons.arrow_back,
                  title: 'كشف حساب',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                        Navigator.pushNamed(context, KashfHesab.id);
                  }),
                    RoundedButton(
                        icon: Icons.arrow_back,
                  title: 'مجمل الذمم',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                    Navigator.pushNamed(context, ZemamReport.id);
                  }),
                   RoundedButton(
                      icon: Icons.arrow_back,
                  title: 'مجمل الديون',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                    Navigator.pushNamed(context, SanadatReport.id, arguments: {
                                      'a_code': "1"
                                    },);
                  }),
                   RoundedButton(
                      icon: Icons.arrow_back,
                  title: 'مجمل الدفعات',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                
                    Navigator.pushNamed(context, SanadatReport.id, arguments: {
                                      'a_code': "2"
                                    },);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
