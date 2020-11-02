import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/model/score_model.dart';

class PlayerScoreModel {
  Player player;
  List<ScoreModel> scores;
  int gmId;

  PlayerScoreModel(this.player, this.scores, this.gmId);

  int getCurrentScore() {
    if (scores == null || scores.length == 0) {
      return 0;
    } else {
      scores.sort((s1, s2) => s1.round.compareTo(s2.round));
      return scores.last.runningScore;
    }
  }

  bool hasScoreForRound(int round) {
    bool ret = true;
    if (scores == null || scores.length == 0 || scores.length < round) {
      return ret = false;
    }
    return ret;
  }

  ScoreModel findScoreForRound(int round) {
    for (var score in scores) {
      if (score.round == round) {
        return score;
      }
    }
    return null;
  }
}
