import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginthirteen_app/BusinessLogic/calculate_game_winner.dart';
import 'package:ginthirteen_app/BusinessLogic/calculate_player_stats.dart';
import 'package:ginthirteen_app/ViewModels/player_score_model.dart';
import 'package:ginthirteen_app/data/dbhelper.dart';
import 'package:ginthirteen_app/model/game.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/model/score_model.dart';
import 'package:intl/intl.dart';

class ScoreboardScreen extends StatefulWidget {
  Game gm;
  ScoreboardScreen(this.gm);

  @override
  State<StatefulWidget> createState() => ScoreboardState(gm);
}

class ScoreboardState extends State {
  Game gm;
  ScoreboardState(this.gm);

  DbHelper helper = DbHelper();
  int count = 0;
  List<PlayerScoreModel> players;
  //Player currentPlayer;
  //bool hasScoresForRound = false;

  @override
  Widget build(BuildContext context) {
    if (players == null) {
      players = List<PlayerScoreModel>();
      _getPlayerScoreData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.name),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),
                  crossAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          "Round:\n" + gm.currentRound.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          _getWildCard(gm.currentRound),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildPlayerView(),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _moveToNextRound(),
          label: Text("Next Round"),
          icon: new Icon(Icons.navigate_next_rounded),
          heroTag: 'scNextRound'),
    );
  }

  ListView _buildPlayerView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(players[position].player.gameTag),
            subtitle: Text(players[position].player.fullName),
            onTap: () => _showAddScoreView(this.players[position], context),
            leading: CircleAvatar(
                backgroundColor: _getColor(this.players[position]),
                child:
                    Text(this.players[position].getCurrentScore().toString())),
          ),
        );
      },
    );
  }

  void _showAddScoreView(PlayerScoreModel plScore, BuildContext context) {
    TextEditingController scoreController = TextEditingController();
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    if (plScore.hasScoreForRound(gm.currentRound)) {
      scoreController.text = plScore.scores.last.score.toString();
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: Text('Enter Score for ' + plScore.player.gameTag),
          elevation: 24.0,
          //shape: CircleBorder(),
          content: TextField(
            controller: scoreController,
            style: textStyle,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Enter Score',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
          ),
          actions: [
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                _addScore(plScore, scoreController.text);
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }

  void _addScore(PlayerScoreModel pl, String val) {
    print('started adding score... ');
    if (val == null) {
      return;
    }
    print('score to be added: ' + val);
    var curScore = pl.findScoreForRound(gm.currentRound);
    var hasCurScore = curScore == null ? false : true;
    var runningScore = pl.getCurrentScore();
    var score = int.parse(val);

    if (hasCurScore) {
      print('Player has current score and value is: ' +
          curScore.score.toString());
      print('Replacing with: ' + score.toString());
      curScore.runningScore -= curScore.score;
      curScore.runningScore += score;
      curScore.score = score;
      helper.updateData(
          curScore, helper.tblScores, ScoreModelFields.id, curScore.id);
    } else {
      runningScore += score;
      var data =
          ScoreModel(gm.id, pl.player.id, gm.currentRound, score, runningScore);
      print('ScoreModel.Score: ' + data.score.toString());
      print('ScoreModel.RunningScore: ' + data.runningScore.toString());
      helper.insertData(data, helper.tblScores);
    }
    _getPlayerScoreData();
  }

  void _getPlayerScoreData() async {
    List<PlayerScoreModel> plScores = List<PlayerScoreModel>();
    await helper.initializeDb();
    var result = await helper.getPlayers();
    var gmPlayers = result.where((p) => gm.players.contains(p.id)).toList();
    for (var pl in gmPlayers) {
      var scores = await helper.getScoresForPlayer(gm.id, pl.id);
      plScores.add(PlayerScoreModel(pl, scores, gm.id));
    }
    var plCount = plScores.length;
    setState(() {
      players = plScores;
      count = plCount;
    });
  }

  void _moveToNextRound() {
    bool hasScores = players.every((p) => p.hasScoreForRound(gm.currentRound));
    bool isLastRound = gm.currentRound == 13;
    if (hasScores) {
      gm.currentRound++;
      helper.updateData(gm, helper.tblGame, GameFields.id, gm.id);
      if (isLastRound) {
        _finishGame();
      } else {
        _getPlayerScoreData();
      }
    } else {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Enter all Scores"),
        content: Text("Enter all scores before moving to next round!"),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void _finishGame() async {
    var winner = CalculateGameWinner.execute(players);

    // Finish the Game
    gm.gameEnded = new DateFormat.yMd().format(DateTime.now());
    gm.gameWinnerTag = winner.gameTag;
    gm.gameWinnerId = winner.id;
    gm.currentRound = 13;
    await helper.updateData(gm, helper.tblGame, GameFields.id, gm.id);

    for (var plScore in players) {
      var stats =
          CalculatePlayerStats.execute(plScore.player, gm, plScore.scores);
      plScore.player.updateStats(stats);
      await helper.updateData(plScore.player, helper.tblPlayers,
          PlayerFields.id, plScore.player.id);
    }

    Navigator.pop(context, true);
    AlertDialog alertDialog = AlertDialog(
      title: Text("Game Over!"),
      content: Text("The winner was " + winner.gameTag),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Color _getColor(PlayerScoreModel scoreModel) {
    if (scoreModel.hasScoreForRound(gm.currentRound)) {
      return Colors.green;
    }
    return Colors.blue;
  }

  String _getWildCard(int round) {
    String wild = "No Wild";
    var invRound = 14 - round;
    switch (invRound) {
      case 1:
        wild = "Aces are Wild";
        break;
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        wild = "${invRound.toString()}s are Wild";
        break;
      case 11:
        wild = "Jacks are Wild";
        break;
      case 12:
        wild = "Queens are Wild";
        break;
      case 13:
        wild = "Kings are Wild";
        break;
    }
    return wild;
  }
}
