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
final TextEditingController phone_controller = TextEditingController();
final TextEditingController _controller = TextEditingController();
String page_name = "", code = "";
List _loadedPhotos = [];
List _loadedPhotos2 = [];
bool v = false;
int fill = 0;
var focusNode1 = FocusNode();

Future<String> createQabd(BuildContext context, String cName1, String cId1,
    double total1, String notes1, DateTime aDate1, String phone) async {
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
  String sDate =
      "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

  a_date.text = sDate;
  notes.text = "";
  phone_controller.text = "";
  total.text = "";
  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //_controller2.text = title;
    String? msg_link = prefs.getString("msg_link");
    if (msg_link != "") showAlertDialog(context, "", total1, phone);
    return "response.statusCode";
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
    throw Exception('Failed to create album.');
  }
}

Future<bool> showAlertDialog(
    BuildContext context, String message, double total1, phone) async {
  // set up the buttons
  String vString = total1.toInt().toString();
  Widget cancelButton = ElevatedButton(
    child: Text("لا"),
    onPressed: () {
      // returnValue = false;
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("نعم"),
    onPressed: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString("company_name"));
      String? company_id = prefs.getString("company_id");
      String? company_name = prefs.getString("company_name");
      String? msg_link = prefs.getString("msg_link");
      final response;
      if (code == "1") {
        print(
            'https://jerusalemaccounting.yaghco.website/debting/html/ltr/$msg_link.php?x=قيمة اخر عملية شراء $vString شيكل &phone_num=$phone');
        response = await http.post(
          Uri.parse(
              'https://jerusalemaccounting.yaghco.website/debting/html/ltr/$msg_link.php?x=قيمة اخر عملية شراء $vString شيكل &phone_num=$phone'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{}),
        );
      } else {
        print(
            'https://jerusalemaccounting.yaghco.website/debting/html/ltr/$msg_link.php?x=تم دفع مبلغ بقيمة $vString شيكل  &phone_num=$phone');
        response = await http.post(
          Uri.parse(
              'https://jerusalemaccounting.yaghco.website/debting/html/ltr/$msg_link.php?x=تم دفع مبلغ بقيمة $vString شيكل &phone_num=$phone'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{}),
        );
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        //_controller2.text = title;

        print("response.statusCode");
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print(response.statusCode);
        throw Exception('Failed to create album.');
      }
      // returnValue = true;
      Navigator.of(context).pop(true);
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("هل تريد ارسال رسالة ؟"),
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  final result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return result ?? false;
}

class AddQabd extends StatefulWidget {
  static const String id = 'qabd';

  AddQabd({Key? key}) : super(key: key);

  @override
  State<AddQabd> createState() => _AddQabdState();
}

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
  final List data = json.decode(content) ?? [];

  _loadedPhotos = data;
  print(_loadedPhotos);
  _loadedPhotos2 = _loadedPhotos;
}

class _AddQabdState extends State<AddQabd> {
  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _loadedPhotos;
    } else {
      results = _loadedPhotos
          .where((user) => user["c_name"].contains(enteredKeyword))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _loadedPhotos2 = results;
      print(enteredKeyword);
      print(results);
    });
    // setupAlertDialoadContainer(context);
  }

  @override
  Widget build(BuildContext context) {
    // print("_loadedPhotos");

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    //print(arguments['a_code']);
    code = arguments['a_code'];
    if (arguments['a_code'] == "1")
      page_name = "تسجيل دين";
    else
      page_name = "تسجيل دفعة";
    if (fill == 0) {
      _fetchData();
      fill = 1;
      String sDate =
          "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

      a_date.text = sDate.toString();
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
//fill = 0;
        setState(() {
          _fetchData();
          c_id.text = "";
          c_name_controller.text = "";
          String sDate =
              "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

          a_date.text = sDate.toString();
          notes.text = "";
          phone_controller.text = "";
          total.text = "";
          fill = 0;
        });
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          centerTitle: true,
          title: const Text('القدس لمتابعة الديون',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
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
        SizedBox(
          height: 20,
        )
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
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'اسم الزبون :',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18,
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
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "اسم الزبون",
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
                      decoration: const InputDecoration(
                          labelText: 'بحث', suffixIcon: Icon(Icons.search)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: _loadedPhotos.isEmpty
                          ? Center(
                              child: ElevatedButton(
                                onPressed: (_fetchData),
                                child: const Text('loading...'),
                              ),
                            )
                          // The ListView that displays photos
                          : ListView.builder(
                              itemCount: _loadedPhotos2.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border(top: BorderSide())),
                                  child: ListTile(
                                    leading: Text(
                                      _loadedPhotos2[index]["id"],
                                    ),
                                    title:
                                        Text(_loadedPhotos2[index]['c_name']),
                                    onTap: () {
                                      c_name_controller.text =
                                          _loadedPhotos2[index]["c_name"];

                                      c_id.text = _loadedPhotos2[index]['id'];
                                      phone_controller.text =
                                          _loadedPhotos2[index]['phone'];
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
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'الهاتف :',
                  textAlign: TextAlign.right,
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
                  controller: phone_controller,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "الهاتف",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  // obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'التاريخ :',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
              Expanded(
                flex: 1,
                child: Text(
                  'المبلغ :',
                  textAlign: TextAlign.right,
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
              Expanded(
                flex: 1,
                child: Text(
                  'الملاحظات ',
                  textAlign: TextAlign.right,
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
                    context,
                    c_name_controller.text.trim(),
                    c_id.text.trim(),
                    double.parse(total.text.trim()),
                    notes.text.trim(),
                    DateTime.parse(a_date.text.trim()),
                    phone_controller.text.trim());
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
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

    if (!context.mounted)
      return "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    var selectedDate2 = new DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
        DateTime.now().millisecond,
        DateTime.now().microsecond);
    String selectedDate22 =
        "${selectedDate2.year.toString()}-${selectedDate2.month.toString().padLeft(2, '0')}-${selectedDate2.day.toString().padLeft(2, '0')}";

    a_date.text = selectedDate22.toString();

    return selectedDate22;
  }
}
