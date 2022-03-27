import 'dart:async';

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

  var timerStarted = false;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: '
      '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 300;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Open Retro'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Visibility(
                      child: Text(timerText,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      visible: timerStarted),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          timerStarted = !timerStarted;
                        });
                        startTimeout();
                      },
                      icon: const Icon(Icons.timer))
                ],
              ),
            ),
          ],
        ),
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

  int currentSeconds = 0;

  void startTimeout() {
    Timer.periodic(interval, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
}
