
import 'package:alquds_debting/edit_customer.dart';
import 'package:flutter/material.dart';

var Main_Color = Color(0xff34568B);
class ReportZemamCard extends StatefulWidget {
  final balance, c_name, c_id, phone;
  

  ReportZemamCard({
    Key? key,
    required this.phone,
    this.balance,
   
    required this.c_id,
    required this.c_name,
  
  }) : super(key: key);

  @override
  State<ReportZemamCard> createState() => _ReportZemamCardState();
}

class _ReportZemamCardState extends State<ReportZemamCard> {

 

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
                          widget.balance.toString().length > 15
                              ? widget.balance.toString().substring(0, 15) + '...'
                              : widget.balance.toString(),
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
                          "${widget.phone}",
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
                          color: Colors.green,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child:    TextButton(
                               
                                        child: Text("تعديل",  style: TextStyle(color: Colors.black,fontSize: 10),),
                                        onPressed: () {
  Navigator.pushNamed(context, EditCustomer.id, arguments: {
                                      'id': widget.c_id,
                                       'c_name': widget.c_name,
                                        'c_phone': widget.phone
                                    },);

                                         // deleteproduct(
                                           //   _loadedPhotos2[index]['id']);
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
