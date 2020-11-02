import 'package:ginthirteen_app/model/data_model.dart';
import 'package:ginthirteen_app/model/game_stats.dart';

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
  }

  // Getters
  String get fullName => '$firstName $lastName';

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
    if (id != null) {
      map[PlayerFields.id] = id;
    }
    return map;
  }

  void updateStats(GameStats stats) {
    this.avgScore = stats.avgScore;
    this.totalWins = stats.totalWins;
    this.gamesPlayed = stats.gamesPlayed;
    this.winPercent = stats.winPercent;
    this.winStreak = stats.winStreak;
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
}
