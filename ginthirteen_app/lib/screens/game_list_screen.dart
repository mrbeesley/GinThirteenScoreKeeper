import 'package:flutter/material.dart';
import 'package:ginthirteen_app/data/dbhelper.dart';
import 'package:ginthirteen_app/model/game.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/screens/create_game_screen.dart';
import 'package:ginthirteen_app/screens/scoreboard_screen.dart';

class GameListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameListState();
}

class GameListState extends State {
  DbHelper helper = DbHelper();
  List<Game> games;
  List<Player> players;
  int count;

  @override
  Widget build(BuildContext context) {
    if (games == null) {
      games = List<Game>();
      players = List<Player>();
      getData();
    }

    return Scaffold(
      body: buildGameList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateGame(Game('', '', '', 0, '', 0)),
        tooltip: "Start a new Game",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView buildGameList() {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.games[position].name),
            subtitle: Text(this.games[position].gameWinnerTag),
            onTap: () {
              debugPrint("Tapped on " + this.games[position].name);
              _navigateToDetail(this.games[position]);
            },
            leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(this.games[position].currentRound.toString())),
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final gamesFuture = helper.getGames();
      final playersFuture = helper.getPlayers();
      gamesFuture.then((result) {
        count = result.length;
        setState(() {
          games = result;
          count = count;
        });
      });
      playersFuture.then((result) {
        setState(() {
          players = result;
        });
      });
    });
  }

  _navigateToDetail(Game gm) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreboardScreen(gm)));
    if (result == true) {
      getData();
    }
  }

  _navigateToCreateGame(Game gm) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateGameScreen(gm)));
    if (result == true) {
      getData();
    }
  }
}
