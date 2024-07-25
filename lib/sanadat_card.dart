import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
var Main_Color = Color(0xff34568B);
class SanadCard extends StatefulWidget {
  final total, c_name, c_id, date, action_id, notes;
  var actions;

  SanadCard({
    Key? key,
    required this.action_id,
    this.total,
    required this.date,
    required this.c_id,
    required this.c_name,
    required this.notes,
    required this.actions,
  }) : super(key: key);

  @override
  State<SanadCard> createState() => _SanadCardState();
}

class _SanadCardState extends State<SanadCard> {

 
Future deletesanad(String id) async {
  print(
      "https://jerusalemaccounting.yaghco.website/mobile_debt/delete_sanad.php?id=$id");
  final response = await http.get(
    Uri.parse(
        'https://jerusalemaccounting.yaghco.website/mobile_debt/delete_sanad.php?id=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    print("ok");
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
 
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
         scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
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
                          color: Colors.white,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          widget.total.toString().length > 15
                              ? widget.total.toString().substring(0, 15) + '...'
                              : widget.total.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                 
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffDFDFDF),
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          "${widget.c_id}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          "${widget.c_name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffDFDFDF),
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          "${widget.date}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          "${widget.action_id}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                   Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffDFDFDF),
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          "${widget.notes}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                   Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child:    IconButton(
                               iconSize: 25,
                             icon: const Icon(Icons.delete) , color: Colors.red,
                                        
                                        onPressed: () {
                                          deletesanad(
                                              widget.action_id);
                                              
                                        },
                                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
         
        ],
      ),
    );
  }

 
}
