import 'package:ginthirteen_app/model/data_model.dart';

class ScoreModel extends DataModel {
  int id;
  int gameId;
  int playerId;
  int round;
  int score;
  int runningScore;

  // constructor
  ScoreModel(
      this.gameId, this.playerId, this.round, this.score, this.runningScore);
  ScoreModel.withId(this.id, this.gameId, this.playerId, this.round, this.score,
      this.runningScore);
  ScoreModel.fromObject(dynamic o) {
    this.id = o[ScoreModelFields.id];
    this.gameId = o[ScoreModelFields.gameId];
    this.playerId = o[ScoreModelFields.playerId];
    this.round = o[ScoreModelFields.round];
    this.score = o[ScoreModelFields.score];
    this.runningScore = o[ScoreModelFields.runningScore];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[ScoreModelFields.gameId] = gameId;
    map[ScoreModelFields.playerId] = playerId;
    map[ScoreModelFields.round] = round;
    map[ScoreModelFields.score] = score;
    map[ScoreModelFields.runningScore] = runningScore;
    if (id != null) {
      map[ScoreModelFields.id] = id;
    }
    return map;
  }
}

class ScoreModelFields {
  static const id = 'id';
  static const gameId = 'gameId';
  static const playerId = 'playerId';
  static const round = 'round';
  static const score = 'score';
  static const runningScore = 'runningScore';
}
