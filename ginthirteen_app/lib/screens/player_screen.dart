import 'package:flutter/material.dart';
import 'package:ginthirteen_app/components/drawer_menu.dart';
import 'package:ginthirteen_app/data/dbhelper.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/screens/player_detail_screen.dart';

class PlayerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State {
  DbHelper helper = DbHelper();
  List<Player> players;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (players == null) {
      players = List<Player>();
      getData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Players'),
      ),
      drawer: DrawerMenu(),
      body: buildPlayerList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToDetail(Player("", "", "", 0, 0, 0, 0, 0)),
        tooltip: "Add a new Player",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView buildPlayerList() {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(players[position].gameTag),
            subtitle: Text(players[position].fullName),
            onTap: () {
              debugPrint("Tapped on " + this.players[position].gameTag);
              navigateToDetail(this.players[position]);
            },
            leading: CircleAvatar(
                backgroundColor: getColor(this.players[position]),
                child: Text(this.players[position].winStreak.toString())),
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final playersFuture = helper.getPlayers();
      playersFuture.then((result) {
        count = result.length;
        setState(() {
          players = result;
          count = count;
        });
      });
    });
  }

  Color getColor(Player player) {
    if (player.winStreak < 3) {
      return Colors.red;
    } else if (player.winStreak < 5) {
      return Colors.yellow;
    }
    return Colors.green;
  }

  void navigateToDetail(Player player) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlayerDetailScreen(player)));
    if (result == true) {
      getData();
    }
  }
}
