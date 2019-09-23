import 'package:flutter/material.dart';
import 'package:todoapp/models/global.dart';

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkGreyColor,
      child: ListView(
        padding: EdgeInsets.only(top: 300),
        children: getList(),
      ),
    );
  }

  List<Widget> getList() {
    return [
    ];
  }
}