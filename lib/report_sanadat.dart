import 'dart:convert';
import 'dart:io';

import 'package:alquds_debting/qabd.dart';
import 'package:alquds_debting/rounded_button.dart';
import 'package:alquds_debting/sanadat_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:intl/intl.dart';
var Main_Color = Color(0xff34568B);
final TextEditingController start_date= TextEditingController();
final TextEditingController end_date = TextEditingController();
  String page_name = "",code = ""; 
int fill = 0;
double blnc = 0;
class SanadatReport extends StatefulWidget {
  
    static const String id = 'report_sanadat';
  SanadatReport({Key? key}) : super(key: key);

  @override
  State<SanadatReport> createState() => _SanadatReportState();
}

class _SanadatReportState extends State<SanadatReport> {
  

List _loadedPhotos = [];
List _loadedPhotos2 = [];
   setStart() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
     String formattedDate ="${pickedDate.year.toString()}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";
      // print(
      //     formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        start_date.text = formattedDate; //set output date to TextField value.
      });
      if (start_date.text != "") {
        _runFilter();
      } else {
        _fetchData();
      }
    } else {
      // print("Date is not selected");
    }
 //   _runFilter();
  }

  setEnd() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      //String formattedDate = pickedDate.toString();
      String formattedDate ="${pickedDate.year.toString()}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";
      // print(
      //     formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        end_date.text = formattedDate; //set output date to TextField value.
      });
       if (end_date.text != "") {
        _runFilter();
      } else {
        _fetchData();
      }
    } else {
      // print("Date is not selected");
    }
  }

  Future<void>  _fetchData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
String? company_id = prefs.getString("company_id");
    final apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_sanadat.php?allow=yes&company_id=$company_id&a_code=$code';
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
       blnc += double.parse( _loadedPhotos[i]['total'].toString());
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
    var parsedDate = DateTime.parse(start_date.text);
     var parsedDate2 = DateTime.parse(end_date.text);
for(var item in _loadedPhotos){
  print( _loadedPhotos.length);

   var itemDate = DateTime.parse(item["a_date"].toString());
 DateTime itemDate2 =DateTime.parse("${itemDate.year.toString()}-${itemDate.month.toString().padLeft(2,'0')}-${itemDate.day.toString().padLeft(2,'0')}");
    
   if(itemDate2.compareTo(parsedDate) >= 0 && itemDate2.compareTo(parsedDate2) <= 0) {
    
    results.add(item);
    print( "3");
   }
 }
    // Refresh the UI
    setState(() {
      _loadedPhotos2 = results;
      blnc = 0;
        for (var i = 0; i < _loadedPhotos2.length; i++) {
       blnc += double.parse( _loadedPhotos2[i]['total'].toString());
      }
       print(parsedDate);
          print(parsedDate2);
          print(results);
    });
  }

  @override
  Widget build(BuildContext context) {
 final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    print(arguments['a_code']);
   code = arguments['a_code'];

if(arguments['a_code'] == "1")
         page_name = "الديون";
         else
          page_name = "الدفعات";

    if (fill == 0) {
      _fetchData();
         start_date.text = "${DateTime.now().year.toString()}-${"01".padLeft(2,'0')}-${"01".padLeft(2,'0')}";
      end_date.text = "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}";
    
      fill = 1;
    }
  
    return PopScope(
      canPop: true,
       onPopInvoked : (didPop) {
//fill = 0;
setState(() {
  //_fetchData();
blnc = 0;
  //fill = 0;
  
});
return ;
       },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          centerTitle: true,
          title: const Text('القدس لمتابعة الديون', textAlign: TextAlign.right,
        style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold)),
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
           Padding(
                      padding:
                          const EdgeInsets.only(right: 25, left: 25, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: TextField(
                                onChanged: (value) => _runFilter(),
                                onTap:  setStart,
                                controller: start_date,
                                readOnly: true,
                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.center,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'من تاريخ',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 14),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Main_Color, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xffD6D3D3)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: TextField(
                                 onChanged: (value) => _runFilter(),
                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.center,
                                onTap: setEnd,
                                controller: end_date,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'الى تاريخ',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 14),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Main_Color, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xffD6D3D3)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
           Directionality(
        textDirection: TextDirection.ltr,
            child:  RoundedButton(
             icon: Icons.search,
                    title: 'بحث',
                    colour: Color.fromRGBO(58, 66, 86, 1.0),
                    onPressed: () {
                      _runFilter();
                    }),
           ),
                     Row(
                      children: [
                       Text(' المجموع :', textAlign: TextAlign.right,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(width: 20,),
                         Text(  blnc.toString(), textAlign: TextAlign.right,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
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
                                            "التاريخ",
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
                                            "رقم السند",
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
                                            "ملاحظات",
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
                                          "حذف",
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
                  return SanadCard(
                                        actions: "'action'",
                                        action_id: _loadedPhotos2[index]['id'] ?? "",
                                        c_id: _loadedPhotos2[index]['c_id'] ?? "",
                                        c_name: _loadedPhotos2[index]['c_name'] ?? "",
                                        total: _loadedPhotos2[index]['total'] ?? "",
                                        notes:_loadedPhotos2[index]['notes'] ?? "",
                                        date: _loadedPhotos2[index]['a_date'].substring(0, 10) ?? "",
                                        
                                      );
                }, 
              ),
                                    ],
            ),
          ),
          ),
        
      ),
    );
  }
}