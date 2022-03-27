import 'package:flutter/material.dart';

class RetroColumn extends StatefulWidget {
  List<String> cardList = [];

  RetroColumn({Key? key}) : super(key: key);

  @override
  State<RetroColumn> createState() => _RetroColumnState();
}

class _RetroColumnState extends State<RetroColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
                width: 400,
                child: TextField(
                  textAlign: TextAlign.center,
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
                      // final index = i ~/ 2;
                      // if (i.isOdd) {
                      //   return const Divider();
                      // }
                      return _buildRow(widget.cardList, i);
                    }))
          ]),
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
    var myController = TextEditingController();
    return Builder(builder: (context) {
      return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Add Comment",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: myController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    debugPrint("save clicked");
                    debugPrint(myController.text);
                    setState(() {
                      widget.cardList.add(myController.text);
                    });
                    debugPrint(widget.cardList[0]);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              )
            ],
          ));
    });
  }

  static const _biggerFont = TextStyle(fontSize: 18.0);

  //key = index of card
  //value = vote count
  var cardsVoteMap = <int, int>{};

  Widget _buildRow(List<String> cardList, int index) {
    if (cardsVoteMap[index] == null) {
      cardsVoteMap[index] = 0;
    }
    return Card(
      color: Colors.white60,
      child: ListTile(
        title: Text(
          cardList[index],
          style: _biggerFont,
        ),
        subtitle: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                var voteCount = cardsVoteMap[index];
                if (voteCount == null) {
                  voteCount = 0;
                  setState(() {
                    cardsVoteMap[index] = voteCount!;
                  });
                } else {
                  voteCount++;
                  setState(() {
                    cardsVoteMap[index] = voteCount!;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                var voteCount = cardsVoteMap[index];
                if (voteCount != null && voteCount > 0) {
                  setState(() {
                    voteCount = voteCount! - 1;
                    cardsVoteMap[index] = voteCount!;
                  });
                }
              },
            ),
            Text("Votes: " + cardsVoteMap[index].toString())
          ],
        ),
      ),
    );
  }
}
