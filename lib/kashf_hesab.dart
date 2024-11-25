import 'dart:convert';
import 'dart:io';

import 'package:alquds_debting/kashf_card.dart';
import 'package:alquds_debting/rounded_button.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
var Main_Color = Color(0xff2196F3);
final TextEditingController c_name_controller = TextEditingController();
final TextEditingController c_id = TextEditingController();
int fill = 0;
double blnc = 0;
final TextEditingController _controller = TextEditingController();

List _loadedcust = [];
List _loadedcust2 = [];
bool v = false;

var focusNode1 = FocusNode();

class KashfHesab extends StatefulWidget {
  static const String id = 'kashf_hesab';
  KashfHesab({Key? key}) : super(key: key);

  @override
  State<KashfHesab> createState() => _KashfHesabState();
}

class _KashfHesabState extends State<KashfHesab> {
  String _selectedLanguage = 'ar'; // Default to Arabic

  @override
  void initState() {
    super.initState();
    _loadSharedPreference();
  }

  Future<void> _loadSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ??
          'ar'; // Default to Arabic if no preference is set
    });
  }

  List _loadedPhotos = [];

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _loadedcust;
    } else {
      results = _loadedcust
          .where((user) => user["c_name"].contains(enteredKeyword))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _loadedcust2 = results;
      print(enteredKeyword);
      print(results);
    });
    // setupAlertDialoadContainer(context);
  }

  Future<void> _fetchData() async {
    var c_id2 = c_id.text;
    if (c_id2 != "") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? company_id = prefs.getString("company_id");
      var apiUrl =
          'https://jerusalemaccounting.yaghco.website/mobile_debt/get_kashf.php?allow=yes&company_id=$company_id&c_id=$c_id2';
      print(apiUrl);
      HttpClient client = HttpClient();
      client.autoUncompress = true;

      final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      final HttpClientResponse response = await request.close();

      final String content = await response.transform(utf8.decoder).join();
      final List data = json.decode(content) ?? [];

      setState(() {
        
        _loadedPhotos = data;
        if(_selectedLanguage != "ar")
        {
for(int i = 0 ; i<_loadedPhotos.length ;i++)
  if( _loadedPhotos[i]['bayan'] == "دين")
  _loadedPhotos[i]['bayan'] = "Debt";
  else if( _loadedPhotos[i]['bayan'] == "دفعة")
  _loadedPhotos[i]['bayan'] = "Payment";

        }
        print(_loadedPhotos);
        blnc = double.parse(
            _loadedPhotos[_loadedPhotos.length - 1]['balance'].toString());
        print("_loadedPhotos");
      });
      listPDFAll.clear();
      listPDFAll.addAll(_loadedPhotos);
      print(listPDFAll);
    }
  }

  Future<void> _fetchCust() async {
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
    final List data = json.decode(content) ?? [];

    setState(() {
      
      _loadedcust = data;
      print(_loadedcust);
      _loadedcust2 = _loadedcust;
      print("_loadedcust");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fill == 0) {
      //  _fetchData();
      _fetchCust();
      fill = 1;
    }
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
//fill = 0;
        setState(() {
          c_name_controller.text = "";
          //fill = 0;
          blnc = 0;
        });
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 8, 29, 82),
                  Color.fromARGB(255, 5, 58, 42)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            _selectedLanguage == 'ar' ? 'القدس لمتابعة الديون' : 'Al-Quds Debt',
            style: GoogleFonts.cairo(
              textStyle: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: _selectedLanguage == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Column(
              children: [
                Visibility(
                  visible: false,
                  child: TextField(
                    enabled: false,
                    controller: c_id,
                    textAlign: _selectedLanguage == 'ar'
                        ? TextAlign.right
                        : TextAlign.left,
                    decoration: InputDecoration(
                        hintText: _selectedLanguage == 'ar'
                            ? "رقم الزبون" :'Customer ID',
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
                      child: Text(
                        _selectedLanguage == 'ar' ? 'اسم الزبون :' : 'Name:',
                        textAlign: _selectedLanguage == 'ar'
                            ? TextAlign.right
                            : TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onTap: () {
                          setState(() {
                            _controller.text = "";
                            _runFilter("");
                            v = true;
                            focusNode1.requestFocus();
                          });
                        },
                        controller: c_name_controller,
                        textAlign: _selectedLanguage == 'ar'
                            ? TextAlign.right
                            : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: _selectedLanguage == 'ar'
                            ? "اسم الزبون" :'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        // obscureText: true,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Color.fromRGBO(58, 66, 86,
                              1.0), // Set to transparent to show gradient
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 6.0,
                          shadowColor: Colors.black38,
                        ),
                        icon:
                            Icon(Icons.search, color: Colors.white, size: 28.0),
                        label: Text(
                          '',
                        ),
                        onPressed: () {
                          _fetchData();
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: v,
                  child: Container(
                      height: 300.0, // Change as per your requirement
                      width: 300.0, // Change as per your requirement
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          TextField(
                            focusNode: focusNode1,
                            controller: _controller,
                            autofocus: true,
                            onChanged: (value) => _runFilter(value),
                            decoration: InputDecoration(
                                labelText:_selectedLanguage == 'ar'
                            ? 'بحث':'Search',
                                suffixIcon: Icon(Icons.search)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: _loadedcust.isEmpty
                                ? Center(
                                    child: ElevatedButton(
                                      onPressed: (_fetchCust),
                                      child: const Text('loading...'),
                                    ),
                                  )
                                // The ListView that displays photos
                                : ListView.builder(
                                    itemCount: _loadedcust2.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            border: Border(top: BorderSide())),
                                        child: ListTile(
                                          leading: Text(
                                            _loadedcust2[index]["id"],
                                          ),
                                          title: Text(
                                              _loadedcust2[index]['c_name']),
                                          onTap: () {
                                            c_name_controller.text =
                                                _loadedcust2[index]["c_name"];

                                            c_id.text =
                                                _loadedcust2[index]['id'];

                                            setState(() {
                                              v = false;
                                            });
                                            // Navigator.of(context).pop(false);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                    _selectedLanguage == 'ar'
                            ?  ' الرصيد :' :'Total :',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(blnc.toString(),
                        textAlign: _selectedLanguage == 'ar'
                            ? TextAlign.right :TextAlign.left  ,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                             Spacer(),
    Padding(
      padding: const EdgeInsets.fromLTRB(15.0,0,15,0),
      child: _buildRoundedButton(
        context,
        icon: Icons.picture_as_pdf,
        title: _selectedLanguage == 'ar' ? 'PDF' : "PDF",
        onPressed: () {
          pdfPrinterA4(true);
        },
      ),
    ),  
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
                                  border: Border.all(color: Color(0xffD6D3D3))),
                              child: Center(
                                child: Text(
                                 _selectedLanguage == 'ar'
                            ? "الرصيد" :"Total",
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
                                  border: Border.all(color: Color(0xffD6D3D3))),
                              child: Center(
                                child: Text(
                                  _selectedLanguage == 'ar'
                            ?  "منه" :'From',
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
                                  border: Border.all(color: Color(0xffD6D3D3))),
                              child: Center(
                                child: Text(
                                   _selectedLanguage == 'ar'
                            ? "له" :"To",
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
                                  border: Border.all(color: Color(0xffD6D3D3))),
                              child: Center(
                                child: Text(
                                   _selectedLanguage == 'ar'
                            ? "البيان" :"Type",
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
                                  border: Border.all(color: Color(0xffD6D3D3))),
                              child: Center(
                                child: Text(
                                _selectedLanguage == 'ar'
                            ?   "التاريخ" :"Date",
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
                                  border: Border.all(color: Color(0xffD6D3D3))),
                              child: Center(
                                child: Text(
                                   _selectedLanguage == 'ar'
                            ? "رقم السند" :"ID",
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
                  itemCount: _loadedPhotos.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime f = DateTime.parse(_loadedPhotos[index]['a_date']);
                    String sDate =
                        "${f.year.toString()}-${f.month.toString().padLeft(2, '0')}-${f.day.toString().padLeft(2, '0')}";

                    return KashfCard(
                      actions: "'action'",
                      action_id: _loadedPhotos[index]['id'] ?? "",
                      balance: _loadedPhotos[index]['balance'] ?? "",
                      bayan: _loadedPhotos[index]['bayan'] ?? "",
                      mnh: _loadedPhotos[index]['mnh'] ?? "",
                      lah: _loadedPhotos[index]['lah'] ?? "",
                      date: sDate ?? "",
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
  
  Widget _buildRoundedButton(BuildContext context, {required IconData icon, required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Directionality(
        textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 45, 65), 
                Color.fromARGB(255, 14, 165, 92),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              backgroundColor: Colors.transparent,
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
  var listPDFAll = [];

pw.Padding firstrowPDF(int index, bool A4, var arabicFont) {
  return pw.Padding(
    padding: A4
        ? pw.EdgeInsets.only(right: 15, left: 15, top: 15)
        : pw.EdgeInsets.only(top: 15),
    child: pw.Container(
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                          
                      "${listPDFAll[index]['id'] ?? "-"}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: A4 ? 14 : 5,
                           font: arabicFont),
                    ),
                  ),
                ),
              ),
              
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Expanded(
                  flex: 2,
                  child: pw.Center(
                    child: pw.Text(
                      
                      "${DateTime.parse(listPDFAll[index]['a_date']).year.toString()}-${DateTime.parse(listPDFAll[index]['a_date']).month.toString().padLeft(2, '0')}-${DateTime.parse(listPDFAll[index]['a_date']).day.toString().padLeft(2, '0')}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: A4 ? 14 : 5,
                           font: arabicFont),
                    ),
                  ),
                ),
              ),
                pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                          
                      "${listPDFAll[index]['bayan'] ?? "-"}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: A4 ? 14 : 5,
                           font: arabicFont),
                    ),
                  ),
                ),
              ),
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Expanded(
                  flex: 3,
                  child: pw.Center(
                    child: pw.Text(
                      "${listPDFAll[index]['lah'] ?? ""}",
                      style: pw.TextStyle(fontSize: A4 ? 14 : 5,
                           font: arabicFont),
                    ),
                  ),
                ),
              ),
                pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                      "${listPDFAll[index]['mnh'].toString()}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: A4 ? 14 : 5,
                           font: arabicFont),
                    ),
                  ),
                ),
              ),
            
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                      "${listPDFAll[index]['balance'].toString()}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: A4 ? 14 : 5,
                           font: arabicFont),
                    ),
                  ),
                ),
              ),
            
            ],
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10),
            child: pw.Container(
              width: double.infinity,
              height: 2,
              color: PdfColors.grey,
            ),
          )
        ],
      ),
    ),
  );
}
pdfPrinterA4(bool withproduct) async {
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Hacen_Tunisia.ttf"));
    List<pw.Widget> widgets = [];
    final title = pw.Column(
      children: [
        pw.Center(
          child: pw.Directionality(
              textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
            child: pw.Text(
             _selectedLanguage == 'ar'
                  ? "كشف حساب" :"Account statement",
              style: pw.TextStyle(fontSize: 20),
            ),
          ),
        ),
          pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            
            pw.Directionality(
                textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
                child: pw.Text(_selectedLanguage == 'ar'
                  ? "السيد : "+listPDFAll[0]['c_name'].toString() :blnc.toString())),
          ],
        ),
        pw.SizedBox(
          height: 20,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            
            pw.Directionality(
                textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
                child: pw.Text(_selectedLanguage == 'ar'
                  ? "الرصيد النهائي : "+blnc.toString() : "Final Balance :" +blnc.toString())),
          ],
        ),
        pw.SizedBox(
          height: 20,
        ),
      ],
    );
    widgets.add(title);
    final firstrow = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Directionality(
           textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
          child: pw.Expanded(
            flex: 1,
            child: pw.Center(
              child: pw.Text(
               _selectedLanguage == 'ar'
                  ?  "رقم السند" :"ID",
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        pw.Directionality(
            textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
          child: pw.Expanded(
            flex: 2,
            child: pw.Center(
              child: pw.Text(
             _selectedLanguage == 'ar'
                  ?    "التاريخ" :"Date",
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
          pw.Directionality(
            textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
          child: pw.Expanded(
            flex: 2,
            child: pw.Center(
              child: pw.Text(
             _selectedLanguage == 'ar'
                  ?    "البيان" :"Type",
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        pw.Directionality(
           textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
          child: pw.Expanded(
            flex: 3,
            child: pw.Center(
              child: pw.Text(
              _selectedLanguage == 'ar'
                  ?   "له" :"To",
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        pw.Directionality(
           textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
          child: pw.Expanded(
            flex: 1,
            child: pw.Center(
              child: pw.Text(
              _selectedLanguage == 'ar'
                  ?   "منه" : "From",
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
       pw.Directionality(
           textDirection:  _selectedLanguage == 'ar'
                  ?pw.TextDirection.rtl :pw.TextDirection.ltr ,
          child: pw.Expanded(
            flex: 1,
            child: pw.Center(
              child: pw.Text(
              _selectedLanguage == 'ar'
                  ?   "الرصيد" : "Balance",
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
    widgets.add(firstrow);
    final firstpadding = pw.Padding(
      padding: pw.EdgeInsets.only(top: 10),
      child: pw.Container(
        width: double.infinity,
        height: 2,
        color: PdfColors.grey,
      ),
    );
    widgets.add(firstpadding);
    final listview = pw.ListView.builder(
      itemCount: listPDFAll.length,
      itemBuilder: (context, index) {
        return firstrowPDF(index, true,arabicFont);
      },
    );
    widgets.add(listview);
  
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        maxPages: 20,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, //here goes the widgets list
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
