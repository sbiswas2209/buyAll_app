import 'dart:convert';

import 'package:buy_all/pages/auth/loginPage.dart';
import 'package:buy_all/pages/common/constants.dart';
import 'package:buy_all/pages/home/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _email = null, _password = null, _name = null, _phone = null;
  bool _loading = false;
  final _secureStorage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppbar(
        title: 'Sign Up',
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
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0 , 20.0 , 0.0 , 20.0),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                ),
              ),
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
                  if(_email == null || _password == null || _name == null || _phone == null){
                    Toast.show('Invalid Fields', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                  else{
                    setState(() {
                      _loading = true;
                    });
                    var data = {
                      "name": _name,
                      "phone": _phone,
                      "email": _email,
                      "password": _password
                    };
                    print(data.toString());
                    var response = await http.post(
                      '$api/signUp',
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
                    if(response.statusCode == 201){
                      await _secureStorage.write(key: 'uid', value: jsonDecode(response.body.toString())['uid']);
                      var uid = await _secureStorage.read(key: 'uid');
                      print(uid);
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage(uid: jsonDecode(response.body.toString())['uid'],)));
                    }
                    else{
                      Toast.show('${jsonDecode(response.body.toString())['message']}', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    }
                  }
                },
                child: Text('Sign Up')
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
                },
                child: Text('Login')
              ),
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}