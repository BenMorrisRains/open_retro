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
  @override
  Widget build(BuildContext context) {
    widget.columnTitleController.text = widget.columnTitle;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 400,
                  child: TextField(
                    cursorColor: Colors.blueGrey,
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    controller: widget.columnTitleController,
                  )),
              IconButton(
                  onPressed: _showCardForColumn, icon: const Icon(Icons.add)),
              SizedBox(
                  width: 400,
                  height: 500,
                  child: ListView.builder(
                      itemCount: widget.cardList.length,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, i) {
                        return _buildRow(widget.cardList, i);
                      }))
            ]),
      ),
    );
  }

  void _showCardForColumn() {
    showDialog(
        context: context,
        builder: (context) {
          return _addCardDialog();
        });
  }

  Widget _addCardDialog() {
    var titleController = TextEditingController();
    var bodyTextController = TextEditingController();
    var summaryEmpty = false;
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
                          errorText: summaryEmpty ? "Please add a brief summary." : null
                        ))),
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

  static const _biggerFont =
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  Widget _buildRow(List<CardModel> cardList, int index) {

    if (widget.cardsVoteMap[index] == null) {
      widget.cardsVoteMap[index] = 0;
    }

    return Card(
      elevation: 3.0,
      color: Colors.white60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Colors.white60,
            title: Text(
              cardList[index].title,
              style: _biggerFont,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                cardList[index].body,
                style: const TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              color: Colors.white60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
            ),
          ),
        ],
      ),
    );
  }
}
