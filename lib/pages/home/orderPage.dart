import 'dart:convert';

import 'package:buy_all/pages/common/constants.dart';
import 'package:buy_all/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class OrderPage extends StatefulWidget {

  final String itemUid;
  final String name;

  OrderPage({@required this.itemUid, @required this.name});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _location = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppbar(title: 'Order'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: TextField(
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: 'Address'
              ),
              onChanged: (value) {
                setState(() {
                  _location = value;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.black,
        onPressed: () async {
          if(_location != null){
            final _storage = FlutterSecureStorage();
          var uid = await _storage.read(key: 'uid');
          var data = {
            'name': widget.name,
            'itemUid': widget.itemUid,
            'buyerUid': uid,
            'quantity': 1,
            'address': _location,
          };
            var response = await http.post(
              '$api/order',
              headers: <String , String>{
                'Content-Type': 'application/json; charset=UTF-8'
              },
              body: jsonEncode(data),
            );
            if(response.statusCode == 201){
              Toast.show('Order Placed', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage(uid: uid)));
            }
            else{
              var data = jsonDecode(response.body.toString());
              Toast.show('${data['message']}', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage(uid: uid)));
            }
          }
        },
      ),
    );
  }
}