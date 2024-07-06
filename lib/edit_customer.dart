import 'dart:convert';
import 'package:alquds_debting/kashf_hesab.dart';
import 'package:alquds_debting/report_mogmal_zemam.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
final TextEditingController _controller1 = TextEditingController();
final TextEditingController _controller2 = TextEditingController();
final TextEditingController _idcontroller = TextEditingController();


  Future<String> createCustomer(String c_name,String c_phone,String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
String? company_id = prefs.getString("company_id");
  print('https://jerusalemaccounting.yaghco.website/mobile_debt/edit_cust.php?company_id=$company_id&c_name=$c_name&c_phone=$c_phone&id=$id');
  final response = await http.post(
    Uri.parse('https://jerusalemaccounting.yaghco.website/mobile_debt/edit_cust.php?company_id=$company_id&c_name=$c_name&c_phone=$c_phone&id=$id'),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'company_id': company_id ?? "0",
      'c_name': c_name,
      'c_phone': c_phone,
    }),
    
  );

_controller2.text = "";
  _controller1.text = "";
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //_controller2.text = title;
    return "response.statusCode";
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode );
    throw Exception('Failed to create album.');
  }
  
}



class EditCustomer extends StatefulWidget {
    static const String id = 'edit_customer';
  EditCustomer({Key? key}) : super(key: key);

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    print(arguments['id']);
    setState(() {
         _idcontroller.text = arguments['id'];
   _controller1.text = arguments['c_name'];
   _controller2.text = arguments['c_phone'];
    });


    return  Scaffold(
        appBar: AppBar(
             elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
 centerTitle: true,
        title:  const Text('القدس لمتابعة الديون' ,textAlign: TextAlign.right,
        style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
   
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
             _header(context),
           _inputField(context),
          
          ],
        ),
      ),
    );
  }
  _header(context) {
    return  Column(
      children: [
        Text(
          "تعديل زبون",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        //Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          Visibility(
            visible: false,
            child: TextField(
              controller:  _idcontroller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                hintText: "رقم الزبون",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none
                ),
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                suffixIcon: const Icon(Icons.person)),
                    ),
          ),
        TextField(
            controller:  _controller1,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              hintText: "اسم الزبون",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
              suffixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
            controller:  _controller2,
           textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: "رقم الهاتف",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            suffixIcon: const Icon(Icons.phone),
          ),
       
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if(_controller1.text.trim() != "") {
           //  Navigator.pushNamed(context,FirstPage.id);
          await createCustomer( _controller1.text.trim() , _controller2.text.trim() , _idcontroller.text.trim());
       
         Navigator.pushNamed(context, ZemamReport.id);
            }
            else
            {
  showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('الرجاء ادخال اسم الزبون'),
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

            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          ),
          child: const Text(
            "تعديل",
            style: TextStyle(fontSize: 20,color: Colors.white,),
          ),
        )
      ],
    );
  }

}