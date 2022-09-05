import 'dart:ffi';

import '../presentation/cardmodel.dart';

class DataProvider {

  Future<Bool> persistCard(CardModel card) {
    //save card
    bool result = false;

    return result;
  }


  Future<CardModel> getCardModel(String uuid) {
    //get card model from database
    return null;
  }
}