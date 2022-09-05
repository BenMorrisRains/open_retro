import 'package:uuid/uuid.dart';

class CardModel {
  String title = "";
  String body = "";
  int upVotes = 0;
  int downVotes = 0;
  String uuid = "";
  String author = "Brains";
  CardModel(this.title, this.body) {
    uuid = const Uuid().toString();
  }
}