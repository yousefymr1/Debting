import 'dart:convert';
import 'dart:io';

import 'package:alquds_debting/qabd.dart';
import 'package:alquds_debting/rounded_button.dart';
import 'package:alquds_debting/sanadat_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
     String _selectedLanguage = 'ar'; // Default to Arabic
   List _loadedPhotos = [];
  List _loadedPhotos2 = [];
    ScrollController _scrollController = ScrollController();
  int _page = 1; // Tracks the current page
  bool _isLoading = false; // Tracks if data is currently being fetched
  bool _hasMoreData = true; // Tracks if more data is available

  @override
  void initState() {
    super.initState();
    // Print to check if the controller is being attached properly
    print("Attaching ScrollController Listener");
    _loadSharedPreference();
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      print("Max Scroll Extent: ${_scrollController.position.maxScrollExtent}");
    });

    _scrollController.addListener(_loadMoreData);  // Attach listener
    _fetchData(); // Fetch initial data
  }
Future<void> _loadSharedPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _selectedLanguage = prefs.getString('language') ?? 'ar';  // Default to Arabic if no preference is set
  });
}
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() async {
  // Ensure we're not already loading data and that there is more data to load
 
  if (!_isLoading && 
      _scrollController.position.pixels >= _scrollController.position.maxScrollExtent -100 ) {
    if (_hasMoreData) {
      setState(() {
        _isLoading = true;
      });
      // Fetch more data and update state
      await _fetchData();
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  Future<void> _fetchData() async {
 
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? company_id = prefs.getString("company_id");
    
    final apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_sanadat.php?allow=yes&company_id=$company_id&a_code=$code&page=$_page'; // Include page parameter in your API
    print(apiUrl);
    
    HttpClient client = HttpClient();
    client.autoUncompress = true;
    
    final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();
    
    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content) ?? [];
    
    setState(() {
      if (data.isEmpty) {
        print("xxx");
        _hasMoreData = false; // If no more data, set this to false
      } else {
          print("yyy");
        _loadedPhotos.addAll(data); // Append new data to the list
        _loadedPhotos2.addAll(data); // Append new data to filtered list (if necessary)
        _page++; // Increase the page number for the next request
      }

      blnc = 0;
      for (var i = 0; i < _loadedPhotos.length; i++) {
        blnc += double.parse(_loadedPhotos[i]['total'].toString());
      }

      _isLoading = false;
      print("_fetchData");
    });
  }

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
if(item["a_date"].toString() != "0000-00-00 00:00:00"){
   var itemDate = DateTime.parse(item["a_date"].toString());
 DateTime itemDate2 =DateTime.parse("${itemDate.year.toString()}-${itemDate.month.toString().padLeft(2,'0')}-${itemDate.day.toString().padLeft(2,'0')}");
    
   if(itemDate2.compareTo(parsedDate) >= 0 && itemDate2.compareTo(parsedDate2) <= 0) {
    
    results.add(item);
   }
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
        _selectedLanguage == 'ar' ? page_name = "الديون" : page_name ="Debts";
         else
        _selectedLanguage == 'ar' ?  page_name = "الدفعات" : page_name ="Payments";

    if (fill == 0) {
     // _fetchData();
         start_date.text = "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2,'0')}-${"01".padLeft(2,'0')}";
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
        body: Directionality(
          
                textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
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
                                hintText:_selectedLanguage == 'ar' ? 'من تاريخ' :"From Date",
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
                                hintText: _selectedLanguage == 'ar' ?'الى تاريخ' : "To Date",
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
                textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child:  RoundedButton(
           icon: Icons.search,
                  title: _selectedLanguage == 'ar' ?'بحث' : "Search",
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                    _runFilter();
                  }),
         ),
                   Row(
                    children: [
                     Text(_selectedLanguage == 'ar' ?' المجموع :' : " Total : ", textAlign: TextAlign.right,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                                          Color.fromRGBO(58, 66, 86, 1.0),
                             Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                         _selectedLanguage == 'ar' ? "المبلغ" : "Total",
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
                                       Color.fromRGBO(58, 66, 86, 1.0),
                             Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                        _selectedLanguage == 'ar' ?  "رقم الزبون" :"C.ID",
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
                                       Color.fromRGBO(58, 66, 86, 1.0),
                             Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                         _selectedLanguage == 'ar' ? "اسم الزبون" : "Name",
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
                                           Color.fromRGBO(58, 66, 86, 1.0),
                             Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                         _selectedLanguage == 'ar' ? "التاريخ" : "Date",
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
                                        Color.fromRGBO(58, 66, 86, 1.0),
                             Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                       _selectedLanguage == 'ar' ?   "رقم السند" : "ID",
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
                                        Color.fromRGBO(58, 66, 86, 1.0),
                             Color.fromRGBO(58, 66, 86, 1.0),
                                          ]),
                                          border:
                                              Border.all(color: Color(0xffD6D3D3))),
                                      child: Center(
                                        child: Text(
                                         _selectedLanguage == 'ar' ? "ملاحظات" : "Notes",
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
                                       Color.fromRGBO(58, 66, 86, 1.0),
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
          
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,  // Attach scroll controller
                 
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(), 
              itemCount: _loadedPhotos2.length + (_isLoading ? 1 : 0),
                         itemBuilder: (BuildContext context, int index) {
                  if (index == _loadedPhotos2.length && _isLoading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SanadCard(
                                        actions: "'action'",
                                        action_id: _loadedPhotos2[index]['id'] ?? "",
                                        c_id: _loadedPhotos2[index]['c_id'] ?? "",
                                        c_name: _loadedPhotos2[index]['c_name'] ?? "",
                                        total: _loadedPhotos2[index]['total'] ?? "",
                                        notes:_loadedPhotos2[index]['notes'] ?? "",
                                        date: _loadedPhotos2[index]['a_date'].substring(0, 10) ?? "",
                                        s_id:_loadedPhotos2[index]['s_id'] ?? "",
                                        
                                      );
                }, 
              ),
            ),
                                  ],
          ),
        ),
        
      ),
    );
  }
}