import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alquds_debting/admin_screen.dart';
import 'package:alquds_debting/first_page.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

final TextEditingController _controller1 = TextEditingController();
final TextEditingController _controller2 = TextEditingController();

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      // ignore: prefer_const_constructors
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation =
        ColorTween(begin: Colors.white, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  List _loadedPhotos = [];

  Future<void> _fetchData() async {
    var dvid = await _getId();
    var apiUrl =
        'https://jerusalemaccounting.yaghco.website/mobile_debt/get_user.php?allow=yes&device_id=$dvid';
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
      _loadedPhotos = data;
      print(_loadedPhotos);

      print("_loadedPhotos");
    });
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        centerTitle: true,
        title: const Text(
          'القدس لمتابعة الديون',
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: animation.value,
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
    return Column(
      children: [
        Text(
          "القدس لمتابعة الديون",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        //Text("Enter your credential to login"),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  _inputField(context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Image.asset(
                  "assets/a.png",
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller1,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                    hintText: "اسم المستخدم",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    suffixIcon: const Icon(Icons.person)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller2,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "كلمة المرور",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                  fillColor: Colors.purple.withOpacity(0.1),
                  filled: true,
                  suffixIcon: const Icon(Icons.password),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print("object");
                  await _fetchData();
                  print("object");
                  if (_controller1.text == "app" &&
                      _controller2.text == "store") {
                    await prefs.setString('company_id', '1');

                    Navigator.pushNamed(context, FirstPage.id);
                  } else if (_controller1.text == "98" &&
                      _controller2.text == "yagh2255") {
                    Navigator.pushNamed(
                      context,
                      AdminScreen.id,
                      arguments: {'active': "1"},
                    );
                  } else if (_controller1.text == "100" &&
                      _controller2.text == "123456789") {
                    Navigator.pushNamed(
                      context,
                      AdminScreen.id,
                      arguments: {'active': "0"},
                    );
                  } else if (_loadedPhotos.isNotEmpty) {
                    if (_controller1.text == _loadedPhotos[0]['name'] &&
                        _controller2.text == _loadedPhotos[0]['password']) {
                      await prefs.setString(
                          'company_id', _loadedPhotos[0]['company_id']);
                      await prefs.setString(
                          'company_name', _loadedPhotos[0]['company_name']);
                      await prefs.setString(
                          'msg_link', _loadedPhotos[0]['msg_link']);
                      print("object");
                      Navigator.pushNamed(context, FirstPage.id);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              'الرجاء التأكد من اسم المستخدم وكلمة المرور'),
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
                  "دخول",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
