import 'dart:convert';

import 'package:buy_all/pages/auth/loginPage.dart';
import 'package:buy_all/pages/common/constants.dart';
import 'package:buy_all/pages/home/itemPage.dart';
import 'package:buy_all/pages/home/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {

  final String uid;

  HomePage({@required this.uid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future getData() async {
    var response = await http.get(
      '$api/allItems',
      headers: <String , String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body.toString());
    print(response.statusCode);
    if(response.statusCode == 200){
      List items = [];

      var data = jsonDecode(response.body.toString())['items'];

      data.forEach((val) {
        items.add(Item(name: val['name'], price: val['price'], quantity: val['quantity'], uid: val['uid']));
      });

      return items;

    }
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppbar(
        title: 'Home Page',
        actions: [
          IconButton(
            onPressed: () async {
              final _storage = FlutterSecureStorage();
              var uid = await _storage.read(key: 'uid');
              print(uid);
              await _storage.delete(key: 'uid');
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
            }, 
            icon: Icon(Icons.exit_to_app), 
          ),
        ]
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${snapshot.data[index].name}'),
                    subtitle: Text('${snapshot.data[index].price}'),
                    onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new ItemPage(name: snapshot.data[index].name, price: snapshot.data[index].price, uid: snapshot.data[index].uid,)))
                  );
                },
              ),
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: Icon(Icons.shopping_bag),
      //   backgroundColor: Colors.black,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}