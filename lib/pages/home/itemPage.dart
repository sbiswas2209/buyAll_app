import 'package:buy_all/pages/common/constants.dart';
import 'package:buy_all/pages/home/orderPage.dart';
import 'package:flutter/material.dart';
class ItemPage extends StatefulWidget {
  final String name;
  final int price;
  final String uid;

  ItemPage({
    @required this.name,
    @required this.price,
    @required this.uid,
  });

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppbar(title: widget.name),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              child: Text('${widget.name}', style: TextStyle(fontSize: 25.0),),
            ),
            Flexible(
              flex: 2,
              child: Text('Rs.${widget.price}', style: TextStyle(fontSize: 20.0),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(widget.uid);
          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new OrderPage(itemUid: widget.uid, name: widget.name,)));
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}