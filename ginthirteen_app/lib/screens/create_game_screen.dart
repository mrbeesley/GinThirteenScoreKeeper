import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ginthirteen_app/components/drawer_menu.dart';
import 'package:ginthirteen_app/model/game.dart';
import 'package:ginthirteen_app/ViewModels/list_item.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/data/dbhelper.dart';
import 'package:intl/intl.dart';

class CreateGameScreen extends StatefulWidget {
  final Game gm;
  CreateGameScreen(this.gm);

  @override
  State<StatefulWidget> createState() => CreateGameState(gm);
}

class CreateGameState extends State {
  Game gm;
  CreateGameState(this.gm);

  DbHelper helper = DbHelper();
  List<ListItem<Player>> players;
  int count = 0;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = gm.name;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    if (players == null) {
      players = List<ListItem<Player>>();
      print('Getting Data...');
      _getData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Game'),
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              style: textStyle,
              onChanged: (val) => _updateName(),
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Select the players you want in this game:',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: getListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(),
        tooltip: "Save & Start the game",
        child: new Icon(Icons.save),
        heroTag: "gmSave",
      ),
    );
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: players[position].isSelected ? Colors.grey : Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(players[position].data.gameTag),
            subtitle: Text(players[position].data.fullName),
            onTap: () => _selectedItem(this.players[position]),
            leading: CircleAvatar(
                backgroundColor: _getColor(this.players[position].data),
                child: Text(this.players[position].data.winStreak.toString())),
          ),
        );
      },
    );
  }

  void _save() async {
    gm.gameStarted = new DateFormat.yMd().format(DateTime.now());
    gm.currentRound = 1;
    print('Game is saving with total num players: ' +
        gm.players.length.toString());
    helper.insertData(gm, helper.tblGame);
    Navigator.pop(context, true);
  }

  void _getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final playersFuture = helper.getPlayers();
      playersFuture.then((result) {
        List<ListItem<Player>> items = List<ListItem<Player>>();
        result.forEach((p) => items.add(ListItem<Player>(p)));
        setState(() {
          players = items;
          count = items.length;
        });
      });
    });
  }

  void _selectedItem(ListItem<Player> item) {
    gm.players.clear();
    item.isSelected = !item.isSelected;
    players
        .where((p) => p.isSelected)
        .forEach((p) => gm.players.add(p.data.id));
    setState(() {
      item.isSelected = item.isSelected;
    });
  }

  void _updateName() {
    gm.name = nameController.text;
  }

  Color _getColor(Player player) {
    if (player.winStreak < 3) {
      return Colors.red;
    } else if (player.winStreak < 5) {
      return Colors.yellow;
    }
    return Colors.green;
  }
}
