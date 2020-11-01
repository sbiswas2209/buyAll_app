import 'dart:convert';

import 'package:buy_all/pages/auth/signUpPage.dart';
import 'package:buy_all/pages/common/constants.dart';
import 'package:buy_all/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;
  bool _loading = false;

  final _secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppbar(
        title: 'Login',
      ),
      body: _loading == false ? Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0 , 20.0 , 0.0 , 20.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              FlatButton(
                onPressed: () async {
                  if(_email == null || _password == null){
                    Toast.show('Invalid Fields', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                  else{
                    setState(() {
                      _loading = true;
                    });
                    var data = {
                      "email": _email,
                      "password": _password
                    };
                    print(data.toString());
                    var response = await http.post(
                      '$api/login',
                      headers: <String , String>{
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                      body: jsonEncode(data)
                    );
                    print(response.statusCode);
                    print(response.body.toString());
                    setState(() {
                      _loading = false;
                    });
                    if(response.statusCode == 200){
                      await _secureStorage.write(key: 'uid', value: jsonDecode(response.body.toString())['uid']);
                      print(response.body.toString());
                      print(jsonDecode(response.body.toString())['uid']);
                      var uid = await _secureStorage.read(key: 'uid');
                      print(uid);
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage(uid: jsonDecode(response.body.toString())['uid'],)));
                    }
                    else{
                      Toast.show('${jsonDecode(response.body.toString())['message']}', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    }
                  }
                },
                child: Text('Login')
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new SignUpPage()));
                },
                child: Text('Sign Up')
              ),
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}