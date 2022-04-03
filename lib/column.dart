import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openretro/cardmodel.dart';

class RetroColumn extends StatefulWidget {
  var columnTitle = "";
  List<CardModel> cardList = [];
  var columnTitleController = TextEditingController();

  //key = index of card
  //value = vote count
  var cardsVoteMap = <int, int>{};

  RetroColumn({Key? key}) : super(key: key);

  @override
  State<RetroColumn> createState() => _RetroColumnState();
}

class _RetroColumnState extends State<RetroColumn> {
  var timerStarted = false;
  int currentSeconds = 0;

final interval = const Duration(seconds: 1);

final int timerMaxSeconds = 300;

  Timer? timer;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: '
      '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    widget.columnTitleController.text = widget.columnTitle;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  cursorColor: Colors.blueGrey,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  controller: widget.columnTitleController,
                ),
                IconButton(
                    onPressed: () {
                      showCardForColumn(-1);
                    },
                    icon: const Icon(Icons.comment, size: 18.0,)),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.cardList.length,
                      itemBuilder: (context, i) {
                        return _buildRow(widget.cardList, i);
                      }),
                )
              ]),
        ),
      ),
    );
  }

  void showCardForColumn(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return _addCardDialog(index);
        });
  }

  void showCardForDiscussion(int index) {
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

    var editingCard = false;

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
                  child: MaterialButton(
                    color: Colors.white12,
                    textColor: Colors.black45,
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
                          widget.cardList.add(CardModel(
                              titleController.text, bodyTextController.text));
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                )
              ],
            ),
          ));
    });
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

  Widget cardForDiscussion(int index) {
    var textForTitle = "";
    var textForBody = "";

    if (index != -1) {
      textForTitle = widget.cardList[index].title;
      textForBody = widget.cardList[index].body;
    }
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
                    Text(textForTitle, style: _cardTitleFont,),
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
  static const _cardTitleFont =
      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  void removeCard(int index, bool edit) {
    if (!edit) {
      widget.cardsVoteMap[index] = 0;
    }
    setState(() {
      widget.cardList.removeAt(index);
    });
  }

  Widget _buildRow(List<CardModel> cardList, int index) {
    if (widget.cardsVoteMap[index] == null) {
      widget.cardsVoteMap[index] = 0;
    }

    return Card(
      elevation: 3.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Colors.white38,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardList[index].title,
                      style: _cardTitleFont,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              showCardForColumn(index);
                            },
                            icon: const Icon(
                              IconData(0xe21a, fontFamily: 'MaterialIcons'),
                              size: 14.0,
                            )),
                        IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              size: 14.0,
                            ),
                            onPressed: () {
                              removeCard(index, false);
                            },
                            color: Colors.black)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    cardList[index].body,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Divider(color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            showCardForDiscussion(index);
                            startTimeout();
                          },
                          icon: Icon(Icons.people_alt_outlined)),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {
                          var voteCount = widget.cardsVoteMap[index];
                          if (voteCount == null) {
                            voteCount = 0;
                            setState(() {
                              widget.cardsVoteMap[index] = voteCount!;
                            });
                          } else {
                            voteCount++;
                            setState(() {
                              widget.cardsVoteMap[index] = voteCount!;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () {
                          var voteCount = widget.cardsVoteMap[index];
                          if (voteCount != null && voteCount > 0) {
                            setState(() {
                              voteCount = voteCount! - 1;
                              widget.cardsVoteMap[index] = voteCount!;
                            });
                          }
                        },
                      ),
                      Text("Votes: " + widget.cardsVoteMap[index].toString())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
