import 'package:ginthirteen_app/ViewModels/player_score_model.dart';
import 'package:ginthirteen_app/model/player.dart';

class CalculateGameWinner {
  static Player execute(List<PlayerScoreModel> players) {
    int winner = 0;
    int lowScore;
    for (var player in players) {
      var score = player.getCurrentScore();
      if (score == null || score < lowScore) {
        winner = player.player.id;
        lowScore = score;
      }
    }

    return players
        .firstWhere((p) => p.player.id == winner, 
          orElse: () => null)
        .player;
  }
}
