import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:openretro/presentation/card_widget.dart';
import 'package:openretro/presentation/card_widget_viewmodel.dart';
import 'package:openretro/presentation/cardmodel.dart';

class RetroColumn extends StatefulWidget {
  var columnTitle = "";
  List<CardModel> cardList = [];
  var columnTitleController = TextEditingController();
  CardWidgetViewModel cardWidgetViewModel = CardWidgetViewModel();

  //key = index of card
  //value = vote count
  HashMap<int, int> cardsVoteMap = HashMap();

  RetroColumn({Key? key}) : super(key: key);

  @override
  State<RetroColumn> createState() => _RetroColumn();
}

class _RetroColumn extends State<RetroColumn> {
  var timerStarted = false;
  late StreamController<int> _events;
  late Timer _timer;
  int _counter = 0;
  var editingCard = false;

  void _startTimer() {
    _counter = 300;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer.cancel();
      //});
      print(_counter);
      _events.add(_counter);
    });
  }

  @override
  initState() {
    super.initState();
    _events = StreamController<int>();
    _events.add(60);
  }

  @override
  Widget build(BuildContext context) {
    widget.columnTitleController.text = widget.columnTitle;
    widget.cardWidgetViewModel.cardList = widget.cardList;
    widget.cardWidgetViewModel.cardVotesMap = widget.cardsVoteMap;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Expanded(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            TextField(
              cursorColor: Colors.blueGrey,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              controller: widget.columnTitleController,
            ),
            IconButton(
                onPressed: () {
                  editCard(-1);
                },
                icon: const Icon(
                  Icons.comment,
                  size: 18.0,
                )),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cardList.length,
                  itemBuilder: (context, i) {
                    widget.cardWidgetViewModel.index = i;
                    widget.cardWidgetViewModel.removeCardBehavior = () {
                      removeCard(i, editingCard);
                    };
                    widget.cardWidgetViewModel.showCardBehavior = () {
                      showCardForDiscussion(i);
                    };
                    widget.cardWidgetViewModel.editCardBehavior = () {
                      editCard(i);
                    };
                    return CardWidget(widget.cardWidgetViewModel);
                  }),
            )
          ]),
        ),
      ),
    );
  }

  void editCard(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return _addCardDialog(index);
        });
  }

  void showCardForDiscussion(int index) {
    debugPrint("index => $index");
    showDialog(
        context: context,
        builder: (context) {
          return cardForDiscussion(index);
        });
  }

  Widget _addCardDialog(int index) {
    var titleController = TextEditingController();
    var bodyTextController = TextEditingController();
    var summaryEmpty = false;

    var textForTitle = "";
    var textForBody = "";

    if (index != -1) {
      textForTitle = widget.cardList[index].title;
      textForBody = widget.cardList[index].body;
      titleController.text = textForTitle;
      bodyTextController.text = textForBody;

      editingCard = true;
    }

    return Builder(builder: (context) {
      return Dialog(
          insetPadding: EdgeInsets.all(200),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          elevation: 3,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                    maxLength: 30,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Card Title:',
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextField(
                        maxLines: 5,
                        controller: bodyTextController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Add a brief summary:',
                            errorText: summaryEmpty
                                ? "Please add a brief summary."
                                : null))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white),
                        primary: Colors.greenAccent,
                        elevation: 7),
                    onPressed: () {
                      if (bodyTextController.text.isEmpty) {
                        setState(() {
                          summaryEmpty = true;
                        });
                      } else {
                        summaryEmpty = false;
                        if (editingCard) {
                          removeCard(index, true);
                        }
                        setState(() {
                          widget.cardWidgetViewModel.cardList.add(CardModel(
                              titleController.text, bodyTextController.text));
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Card"),
                  ),
                )
              ],
            ),
          ));
    });
  }

// void startTimeout() {
//   Timer.periodic(interval, (timer) {
//     setState(() {
//       currentSeconds = timer.tick;
//       if (timer.tick >= timerMaxSeconds) {
//         timer.cancel();
//       }
//     });
//   },);
// }

  Widget cardForDiscussion(int index) {
    var textForTitle = "";
    var textForBody = "";

    if (index != -1) {
      textForTitle = widget.cardList[index].title;
      textForBody = widget.cardList[index].body;
    }

    int currentSeconds = 0;

    const interval = Duration(seconds: 1);

    const int timerMaxSeconds = 300;

    Timer? timer;

    String timerText =
        '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: '
        '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

    Timer.periodic(
      interval,
      (timer) {
        setState(() {
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();
          }
        });
      },
    );

    return Dialog(
        insetPadding: EdgeInsets.all(200),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        elevation: 3,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(timerText),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    textForTitle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(textForBody)),
                ],
              ),
            ],
          ),
        ));
  }

  static const _biggerFont =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  void removeCard(int index, bool edit) {
    if (!edit) {
      widget.cardsVoteMap[index] = 0;
    }
    setState(() {
      widget.cardList.removeAt(index);
    });
  }
}
