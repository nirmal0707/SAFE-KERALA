import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoesDonts extends StatefulWidget {
  @override
  _DoesDontsState createState() => _DoesDontsState();
}

class _DoesDontsState extends State<DoesDonts> {
  bool vis = true;

  callDDs() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        vis = false;
      });
//      Navigator.push(context, CupertinoPageRoute(builder: (context)=>MyHomePage()));
    });
  }

  @override
  void initState() {
    super.initState();
    callDDs();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: vis,
      child: Scaffold(),
    );
  }
}
