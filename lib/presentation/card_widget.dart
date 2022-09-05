import 'package:flutter/material.dart';

import 'card_widget_viewmodel.dart';

class CardWidget extends StatefulWidget {
  CardWidgetViewModel cardWidgetViewModel;

  CardWidget(this.cardWidgetViewModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardWidget();

}

class _CardWidget extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    var viewModel = widget.cardWidgetViewModel;
    var map = viewModel.cardVotesMap;
    var index = viewModel.index;
    var cardList = viewModel.cardList;

    if (map[index] == null) {
      map[index] = 0;
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => viewModel.editCardBehavior(),
                              icon: const Icon(
                                IconData(0xe21a, fontFamily: 'MaterialIcons'),
                                size: 14.0,
                              )),
                          IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                size: 14.0,
                              ),
                              onPressed: () => viewModel.removeCardBehavior(),
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
                        Text(cardList[index].author),

                        IconButton(
                            onPressed: () => viewModel.showCardBehavior(),
                            icon: Icon(Icons.people_alt_outlined)),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            var voteCount = map[index];
                            if (voteCount == null) {
                              voteCount = 0;
                              setState(() {
                                map[index] = voteCount!;
                              });
                            } else {
                              voteCount++;
                              setState(() {
                                map[index] = voteCount!;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () {
                            var voteCount = map[index];
                            if (voteCount != null && voteCount > 0) {
                              setState(() {
                                voteCount = voteCount! - 1;
                                map[index] = voteCount!;
                              });
                            }
                          },
                        ),
                        Text("Votes: " + map[index].toString())
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