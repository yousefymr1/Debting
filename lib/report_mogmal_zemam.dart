import 'dart:convert';
import 'dart:io';

import 'package:alquds_debting/report_zemam_card.dart';
import 'package:alquds_debting/rounded_button.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:intl/intl.dart';
var Main_Color = Color(0xff34568B);
double blnc = 0;
  String page_name = ""; 
int fill = 0;
class ZemamReport extends StatefulWidget {
  
    static const String id = 'report_mogmal_zemam';
  ZemamReport({Key? key}) : super(key: key);

  @override
  State<ZemamReport> createState() => _ZemamReportState();
}

class _ZemamReportState extends State<ZemamReport> {
  

List _loadedPhotos = [];
List _loadedPhotos2 = [];
  

  Future<void> _fetchData() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
String? company_id = prefs.getString("company_id");
    var apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_mogmal_zemam.php?allow=yes&company_id=$company_id';
    print(apiUrl);
    HttpClient client = HttpClient();
    client.autoUncompress = true;

    final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();

    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content);

    setState(() {
      _loadedPhotos = data;
       _loadedPhotos2 = data;
      print(_loadedPhotos);
      blnc = 0;
      for (var i = 0; i < _loadedPhotos.length; i++) {
       blnc += double.parse( _loadedPhotos[i]['balance'].toString());
      }
      print("_fetchData");
    });
  }
Future<void> _runFilter() async {
   await _fetchData();
  print("results" );
  
    List results = [];
    _loadedPhotos2 = [];
      print( "2");
   
for(var item in _loadedPhotos){
  print( _loadedPhotos.length);



    {
    
    results.add(item);
    print( "3");
   }
 }
    // Refresh the UI
    setState(() {
      _loadedPhotos2 = results;
      
          print(results);
    });
  }

  @override
  Widget build(BuildContext context) {
 
          page_name ="مجمل الذمم";

    if (fill == 0) {
      _fetchData();
       
      fill = 1;
    }
  
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        centerTitle: true,
        title: const Text('القدس لمتابعة الديون', textAlign: TextAlign.right,
        style: TextStyle(fontSize: 20,color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        
        child:  Directionality(
          
      textDirection: TextDirection.rtl,
          child: Column(
            children: [
                  Text(
     
          page_name,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        
         RoundedButton(
                  title: 'بحث',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                    _runFilter();
                  }),
                   Row(
                    children: [
                      Text(' المجموع :', textAlign: TextAlign.right,style: TextStyle(fontSize: 20),),
                      SizedBox(width: 20,),
                         Text(  blnc.toString(), textAlign: TextAlign.right),
                    ],
                  ),
              Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Color.fromRGBO(65, 108, 216, 1),
                                            Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                          "المبلغ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                             Color.fromRGBO(65, 108, 216, 1),
                                            Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                          "رقم الزبون",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                               Color.fromRGBO(65, 108, 216, 1),
                                            Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                          "اسم الزبون",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                              
                                 
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                             Color.fromRGBO(65, 108, 216, 1),
                                            Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                          "الهاتف",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                      Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                             Color.fromRGBO(65, 108, 216, 1),
                                            Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                          "تعديل",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
          
            ListView.builder(
              
                 scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(), 
              itemCount: _loadedPhotos2.length,
          itemBuilder: (BuildContext context, int index) { 
                return ReportZemamCard(
                                      
                         
                                      c_id: _loadedPhotos2[index]['c_id'] ?? "",
                                      c_name: _loadedPhotos2[index]['c_name'] ?? "",
                                      balance: _loadedPhotos2[index]['balance'] ?? "",
                                      phone:_loadedPhotos2[index]['phone'] ?? "",
                                   
                                      
                                    );
              }, 
            ),
                                  ],
          ),
        ),
        ),
      
    );
  }
}