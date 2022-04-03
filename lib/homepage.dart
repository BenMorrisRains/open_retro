import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:openretro/column.dart';
import 'package:openretro/columnTitles.dart';

class HomePage extends StatefulWidget {
  var firstColumn = RetroColumn();
  var secondColumn = RetroColumn();
  var thirdColumn = RetroColumn();

  HomePage({Key? key}) : super(key: key) {
    var randomNumber = Random().nextInt(3);
    var listOfColumnNames = <List<String>>[];
    listOfColumnNames.add(ColumnTitles.GSM);
    listOfColumnNames.add(ColumnTitles.HCS);
    listOfColumnNames.add(ColumnTitles.SSC);

    var randomList = listOfColumnNames[randomNumber];

    firstColumn.columnTitle = randomList[0];
    secondColumn.columnTitle = randomList[1];
    thirdColumn.columnTitle = randomList[2];
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var timerStarted = false;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: '
      '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 300;

  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Open Retro", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
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
                        if (!timerStarted) {
                          timer = startTimeout();
                          timerStarted = true;
                        } else {
                          if (timer == null) {
                            debugPrint("timer is null");
                          }
                          timer?.cancel();
                          debugPrint("timer canceled");
                          setState(() {
                            timerStarted = false;
                          });
                          currentSeconds = 0;
                        }
                      },
                      icon: const Icon(Icons.timer))
                ],
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.black54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.firstColumn,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.secondColumn,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.thirdColumn,
              ),
            ],
          ),
        ));
  }


  Timer startTimeout() {
    return Timer.periodic(interval, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
        }
      });
    },);
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
}
