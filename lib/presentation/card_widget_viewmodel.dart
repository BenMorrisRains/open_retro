import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'cardmodel.dart';

class CardWidgetViewModel {
  late List<CardModel> cardList;
  late int index;
  late HashMap<int, int> cardVotesMap;
  late VoidCallback editCardBehavior;
  late VoidCallback showCardBehavior;
  late VoidCallback removeCardBehavior;

}
