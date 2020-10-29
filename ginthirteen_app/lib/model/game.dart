import 'dart:convert';

import 'package:ginthirteen_app/model/data_model.dart';

class Game implements DataModel {
  int id;
  String name;
  String gameStarted;
  String gameEnded;
  int currentRound;
  String gameWinnerTag;
  int gameWinnerId;
  List<int> players = List<int>();

  // Constructor
  Game(this.name, this.gameStarted, this.gameEnded, this.currentRound,
      this.gameWinnerTag, this.gameWinnerId);
  Game.withId(this.id, this.name, this.gameStarted, this.gameEnded,
      this.currentRound, this.gameWinnerTag, this.gameWinnerId);
  Game.fromObject(dynamic o) {
    this.id = o[GameFields.id];
    this.name = o[GameFields.name];
    this.gameStarted = o[GameFields.gameStarted];
    this.gameEnded = o[GameFields.gameEnded];
    this.currentRound = o[GameFields.currentRound];
    this.gameWinnerTag = o[GameFields.gameWinnerTag];
    this.gameWinnerId = o[GameFields.gameWinnerId];
    this.players = List<int>.from(jsonDecode(o[GameFields.players]));
  }

  // Create a map, of the serialized object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[GameFields.name] = name;
    map[GameFields.gameStarted] = gameStarted;
    map[GameFields.gameEnded] = gameEnded;
    map[GameFields.currentRound] = currentRound;
    map[GameFields.gameWinnerTag] = gameWinnerTag;
    map[GameFields.gameWinnerId] = gameWinnerId;
    map[GameFields.players] = jsonEncode(players);
    if (id != null) {
      map[GameFields.id] = id;
    }
    return map;
  }
}

class GameFields {
  static const id = 'id';
  static const name = 'name';
  static const gameStarted = 'gameStarted';
  static const gameEnded = 'gameEnded';
  static const players = 'players';
  static const currentRound = 'currentRound';
  static const gameWinnerTag = 'gameWinnerTag';
  static const gameWinnerId = 'gameWinnerId';
}
