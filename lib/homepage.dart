import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openretro/column.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firstColumn = RetroColumn();
  final secondColumn = RetroColumn();
  final thirdColumn = RetroColumn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Open Retro')),
        body: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[firstColumn, secondColumn, thirdColumn],
            ),
          ),
        ));
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
}
