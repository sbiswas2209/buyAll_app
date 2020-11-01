import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
AppBar titleAppbar(
    {@required String title,
    List<Widget> actions,
    bool automaticallyImplyLeading = true,
    Widget leading}) {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: automaticallyImplyLeading,
    leading: Image.asset('assets/images/icon.png'),
    actions: actions != null ? actions : null,
    title: Text(
      "$title",
      overflow: TextOverflow.fade,
      style: TextStyle(
        color: Colors.white
      ),
    ),
  );
}

const api = 'https://buyallhackathon.herokuapp.com';