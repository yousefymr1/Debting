import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController c_id = TextEditingController();
final TextEditingController c_name_controller = TextEditingController();
late final TextEditingController a_date = TextEditingController();
final TextEditingController notes = TextEditingController();
final TextEditingController total = TextEditingController();
   String page_name = "",code = ""; 
int fill = 0;
Future<String> createQabd( String cName1, String cId1,
    double total1, String notes1, DateTime aDate1) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
String? company_id = prefs.getString("company_id");

  print(
      'https://jerusalemaccounting.yaghco.website/mobile_debt/add_acsarf.php?company_id=$company_id&c_name=$cName1&c_id=$cId1&total=$total1&notes=$notes1&a_date=$aDate1&a_code=$code');
  final response = await http.post(
    Uri.parse(
        'https://jerusalemaccounting.yaghco.website/mobile_debt/add_acsarf.php?company_id=$company_id&c_name=$cName1&c_id=$cId1&total=$total1&notes=$notes1&a_date=$aDate1&a_code=$code'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'company_id': company_id ?? "0",
    }),
  );

  c_id.text = "";
  c_name_controller.text = "";
  String sDate=   "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}";
   
  a_date.text = sDate;
  notes.text = "";
  total.text = "0";
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //_controller2.text = title;
    return "response.statusCode";
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
    throw Exception('Failed to create album.');
  }
}

class AddQabd extends StatefulWidget {
  
  static const String id = 'qabd';

  AddQabd({Key? key}) : super(key: key);

  @override
  State<AddQabd> createState() => _AddQabdState();
  
}

class _AddQabdState extends State<AddQabd> {
  
  @override
  List _loadedPhotos = [];
  List<String> _loadedPhotos2 = [];
  Future<void> _fetchData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
String? company_id = prefs.getString("company_id");
    var apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_custs.php?allow=yes&company_id=$company_id';
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
      print(_loadedPhotos);
      for (var i = 0; i < _loadedPhotos.length; i++) {
        print(_loadedPhotos[i]['c_name']);
        _loadedPhotos2.add(_loadedPhotos[i]['c_name']);
      }
      print("_loadedPhotos");
    });
  }

  Widget build(BuildContext context) {
    // print("_loadedPhotos");
 
     final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    print(arguments['a_code']);
    code = arguments['a_code'];
         if(arguments['a_code'] == "1")
         page_name = "تسجيل دين";
         else
          page_name = "تسجيل دفعة";
    if (fill == 0) {
      _fetchData();
      fill = 1;
      String sDate=   "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}";
   
        a_date.text = sDate.toString();
    }
  
    return PopScope(
      canPop: true,
       onPopInvoked : (didPop) {
//fill = 0;
setState(() {
  _fetchData();
   c_id.text = "";
  c_name_controller.text = "";
    String sDate=   "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}";
   
        a_date.text = sDate.toString();
  notes.text = "";
  total.text = "0";
  fill = 0;
  
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
          child: Padding(
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
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        
        Text(
     
          page_name,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        //Text("Enter your credential to login"),
        SizedBox(height: 20,)
      ],
    );
  }

  _inputField(context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: false,
            child: TextField(
              
              enabled: false,
              controller: c_id,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: "رقم الزبون",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                  fillColor: Colors.purple.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.person)),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('اسم الزبون :' ,textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black,),),
              ),
              Expanded(
                flex: 2,
                child: EasyAutocomplete(
                       
                    controller: c_name_controller,
                    
                    suggestions: _loadedPhotos2,
                    onChanged: (value) => 
                      { 
                      if(_loadedPhotos2.isEmpty)
                      _fetchData(),
                    print('onChanged value: $value'),
                    },
                    onSubmitted: (value) =>
                    {                
                      print('onSubmitted value: $value'),
                       for (var i = 0; i < _loadedPhotos2.length; i++) {
                     if( _loadedPhotos[i]['c_name'] == value)
                    {  
                       c_id.text =  _loadedPhotos[i]['id'] ,
                i = _loadedPhotos2.length,
                    }
                      }
                    },
                    ),
              ),
            ],
          ),
         
      
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(  flex: 1,
                child: Text('التاريخ :' ,textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black,),),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  onTap: () {
                    setState(() {
                      //print(showDateTimePicker(context: context).toString());
                      showDateTimePicker(context: context).toString();
                    });
                  },
                  controller: a_date,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      hintText: "التاريخ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.date_range)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
                Expanded(  flex: 1,
                child: Text('المبلغ :' ,textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black,),),
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: total,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      hintText: "المبلغ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.purple.withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.money)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
                Expanded(  flex: 1,
                child: Text('الملاحظات ' ,textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black,),),
              ),
              Expanded(
                flex:  3,
                child: TextField(
                  controller: notes,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "الملاحظات",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.note),
                  ),
                 // obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (c_id.text.trim() != "" &&
                  total.text.trim() != "" &&
                  total.text.trim() != "0") {
                //  Navigator.pushNamed(context,FirstPage.id);
                createQabd(
                  
                    c_name_controller.text.trim(),
                    c_id.text.trim(),
                    double.parse(total.text.trim()),
                    notes.text.trim(),
                    DateTime.parse(a_date.text.trim()));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('الرجاء ادخال المبلغ'),
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
              "إضافة",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }

  Future<String?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
    var selectedDate2 = new DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
        DateTime.now().millisecond,
        DateTime.now().microsecond);
    String selectedDate22 =   "${selectedDate2.year.toString()}-${selectedDate2.month.toString().padLeft(2,'0')}-${selectedDate2.day.toString().padLeft(2,'0')}";
   
    a_date.text = selectedDate22.toString();
    
    return selectedDate22;
  }
}
