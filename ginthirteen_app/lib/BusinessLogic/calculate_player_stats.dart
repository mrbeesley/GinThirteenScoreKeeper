import 'package:ginthirteen_app/model/game.dart';
import 'package:ginthirteen_app/model/game_stats.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/model/score_model.dart';

class CalculatePlayerStats {
  static GameStats execute(Player pl, Game gm, List<ScoreModel> scores) {
    var stats = GameStats();
    bool isWinner = pl.id == gm.gameWinnerId;
    int score = scores.last.runningScore;

    // Update Games played and wins
    stats.gamesPlayed = pl.gamesPlayed + 1;
    stats.totalWins = isWinner ? (pl.totalWins + 1) : pl.totalWins;
    stats.winStreak = isWinner ? (pl.winStreak + 1) : 0;

    // Calculate the new Average score and Win percentage
    double avgScore =
        ((pl.avgScore * (pl.gamesPlayed - 1)) + score) / pl.gamesPlayed;

    double winPercent = (pl.totalWins / pl.gamesPlayed);

    stats.avgScore = avgScore.toInt();
    stats.winPercent = winPercent.toInt();
    return stats;
  }
}
