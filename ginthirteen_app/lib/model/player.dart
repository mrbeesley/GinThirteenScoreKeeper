import 'dart:convert';

import 'package:ginthirteen_app/model/data_model.dart';

class Player implements DataModel {
  int id;
  String playerSince;
  String firstName;
  String lastName;
  String gameTag;
  int avgScore;
  int totalWins;
  int gamesPlayed;
  int winPercent;
  int winStreak;
  List<int> scoreHistory = List<int>();

  // Constructor
  Player(this.firstName, this.lastName, this.gameTag, this.avgScore,
      this.totalWins, this.gamesPlayed, this.winPercent, this.winStreak);
  Player.withId(
      this.id,
      this.playerSince,
      this.firstName,
      this.lastName,
      this.gameTag,
      this.avgScore,
      this.totalWins,
      this.gamesPlayed,
      this.winPercent,
      this.winStreak);
  Player.fromObject(dynamic o) {
    this.id = o[PlayerFields.id];
    this.playerSince = o[PlayerFields.playerSince];
    this.firstName = o[PlayerFields.firstName];
    this.lastName = o[PlayerFields.lastName];
    this.gameTag = o[PlayerFields.gameTag];
    this.avgScore = o[PlayerFields.avgScore] ?? 0;
    this.totalWins = o[PlayerFields.totalWins] ?? 0;
    this.gamesPlayed = o[PlayerFields.gamesPlayed] ?? 0;
    this.winPercent = o[PlayerFields.winPercent] ?? 0;
    this.winStreak = o[PlayerFields.winStreak] ?? 0;
    this.scoreHistory = List<int>.from(jsonDecode(o[PlayerFields.scoreHistory]));
  }

  // Getters
  String get fullName => '$firstName $lastName';
  int get currentScore => scoreHistory?.fold(0, (prev, cur) => prev + cur);

  void addScore(int val) {
    if (scoreHistory == null) {
      scoreHistory = new List<int>();
    }
    scoreHistory.add(val);
  }

  // Utility Method to make it easier to save
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[PlayerFields.playerSince] = playerSince;
    map[PlayerFields.firstName] = firstName;
    map[PlayerFields.lastName] = lastName;
    map[PlayerFields.gameTag] = gameTag;
    map[PlayerFields.avgScore] = avgScore;
    map[PlayerFields.totalWins] = totalWins;
    map[PlayerFields.gamesPlayed] = gamesPlayed;
    map[PlayerFields.winPercent] = winPercent;
    map[PlayerFields.winStreak] = winStreak;
    map[PlayerFields.scoreHistory] = jsonEncode(scoreHistory);
    if (id != null) {
      map[PlayerFields.id] = id;
    }
    return map;
  }
}

class PlayerFields {
  static const id = 'id';
  static const playerSince = 'playerSince';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const gameTag = 'gameTag';
  static const avgScore = 'avgScore';
  static const totalWins = 'totalWins';
  static const gamesPlayed = 'gamesPlayed';
  static const winPercent = 'winPercent';
  static const winStreak = 'winStreak';
  static const scoreHistory = 'scoreHistory';
}
