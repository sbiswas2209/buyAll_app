import 'package:buy_all/pages/auth/loginPage.dart';
import 'package:buy_all/pages/common/blankPage.dart';
import 'package:buy_all/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future getToken() async {
    final storage = FlutterSecureStorage();
    var uid = await storage.read(key: 'uid');
    print(uid);
    return uid == null ? false : true;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buy All',
      theme: ThemeData(
        primaryColor: Colors.black
      ),
      home: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          print(snapshot.data);
          print(snapshot.hasData);
          if(snapshot.hasData){
            print(snapshot.data);
            if(snapshot.data == false){
              return LoginPage();
            }
            else{
              return HomePage();
            }
          }
          else{
            return BlankPage();
          }
        },
      ),
    );
  }
}