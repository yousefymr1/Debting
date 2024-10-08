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
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1; // Track the current page
  bool _isLoadingMore = false; // Track loading state
  bool _hasMoreData = true; // Flag to check if more data is available

  @override
  void initState() {
    super.initState();
    // Print to check if the controller is being attached properly
    print("Attaching ScrollController Listener");
    
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      print("Max Scroll Extent: ${_scrollController.position.maxScrollExtent}");
    });

    _scrollController.addListener(_loadMoreData);  // Attach listener
    _fetchData(); // Fetch initial data
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() async {
    print("Reached end of scroll");
    if (!_isLoadingMore && 
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      // Add small buffer (50px) before reaching exact bottom to trigger
      if (_hasMoreData) {
        setState(() {
          _isLoadingMore = true;
        });
        print("Fetching more data for page $_currentPage...");
        await _fetchData();
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? company_id = prefs.getString("company_id");

    var apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_mogmal_zemam.php?allow=yes&company_id=$company_id&page=$_currentPage';
    print("API URL: $apiUrl");

    HttpClient client = HttpClient();
    client.autoUncompress = true;
    final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();

    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content) ?? [];

    setState(() {
      if (data.isNotEmpty) {
        print("Data loaded: ${data.length} items");
        _loadedPhotos.addAll(data);
        _loadedPhotos2.addAll(data);
        _currentPage++; // Increment page number for next request
      } else {
        print("No more data available.");
        _hasMoreData = false; // No more data available
      }
    });

    // Calculate balance
    blnc = 0;
    for (var i = 0; i < _loadedPhotos.length; i++) {
      blnc += double.parse(_loadedPhotos[i]['balance'].toString());
    }
    print("Total Balance: $blnc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        centerTitle: true,
        title: const Text('القدس لمتابعة الديون',
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Text(
              "مجمل الذمم",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Directionality(
                textDirection: TextDirection.ltr,
                child: RoundedButton(
                  icon: Icons.search,
                  title: 'بحث',
                  colour: Color.fromRGBO(58, 66, 86, 1.0),
                  onPressed: () {
                    _fetchData();
                  },
                ),
              ),
           Row(
                  children: [
                    Text(
                      ' المجموع :',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(blnc.toString(),
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                  Color.fromRGBO(58, 66, 86, 1.0),
                                 Color.fromRGBO(58, 66, 86, 1.0),
                                  ]),
                                  border: Border.all(color: Color(0xffD6D3D3))),
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
                                   Color.fromRGBO(58, 66, 86, 1.0),
                                 Color.fromRGBO(58, 66, 86, 1.0),
                                  ]),
                                  border: Border.all(color: Color(0xffD6D3D3))),
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
                               Color.fromRGBO(58, 66, 86, 1.0),
                                 Color.fromRGBO(58, 66, 86, 1.0),
                                  ]),
                                  border: Border.all(color: Color(0xffD6D3D3))),
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
                               Color.fromRGBO(58, 66, 86, 1.0),
                                 Color.fromRGBO(58, 66, 86, 1.0),
                                  ]),
                                  border: Border.all(color: Color(0xffD6D3D3))),
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
            Expanded(  // This will make ListView.builder take available height
              child: ListView.builder(
                controller: _scrollController,  // Attach scroll controller
                itemCount: _loadedPhotos2.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == _loadedPhotos2.length && _isLoadingMore) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ReportZemamCard(
                    cust_id: _loadedPhotos2[index]['cust_id'] ?? "",
                    c_id: _loadedPhotos2[index]['c_id'] ?? "",
                    c_name: _loadedPhotos2[index]['c_name'] ?? "",
                    balance: _loadedPhotos2[index]['balance'] ?? "",
                    phone: _loadedPhotos2[index]['phone'] ?? "",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
