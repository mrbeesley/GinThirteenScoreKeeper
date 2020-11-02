import 'package:flutter/material.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/data/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String>[
  'Save Player & Back',
  'Delete Player',
  'Go Back'
];

const mnuSave = 'Save Player & Back';
const mnuDelete = 'Delete Player';
const mnuBack = 'Go Back';

class PlayerDetailScreen extends StatefulWidget {
  final Player player;
  PlayerDetailScreen(this.player);

  @override
  State<StatefulWidget> createState() => PlayerDetailState(player);
}

class PlayerDetailState extends State {
  Player player;
  PlayerDetailState(this.player);
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController gameTagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.text = player.firstName;
    lastNameController.text = player.lastName;
    gameTagController.text = player.gameTag;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(player.fullName),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => select(mnuSave),
            tooltip: "Save Changes",
            child: new Icon(Icons.save),
            heroTag: "plySave",
          ),
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: FloatingActionButton(
                onPressed: () => select(mnuDelete),
                tooltip: "Delete this Player",
                child: new Icon(Icons.delete),
                heroTag: "plyDelete",
              )),
          FloatingActionButton(
            onPressed: () => select(mnuBack),
            tooltip: "Go back, discard changes",
            child: new Icon(Icons.arrow_back),
            heroTag: "plyBack",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: firstNameController,
                  style: textStyle,
                  onChanged: (val) => this.updateFirstName(),
                  decoration: InputDecoration(
                      labelText: "First Name",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: lastNameController,
                    style: textStyle,
                    onChanged: (val) => this.updateLastName(),
                    decoration: InputDecoration(
                        labelText: "Last Name",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                TextField(
                  controller: gameTagController,
                  style: textStyle,
                  onChanged: (val) => this.updateGameTag(),
                  decoration: InputDecoration(
                      labelText: "Game Tag",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (player.id == null) {
          return;
        }
        result = await helper.deleteData(
            helper.tblPlayers, PlayerFields.id, player.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Player"),
            content: Text("The player has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    if (player.id != null) {
      helper.updateData(player, helper.tblPlayers, PlayerFields.id, player.id);
    } else {
      player.playerSince = new DateFormat.yMd().format(DateTime.now());
      helper.insertData(player, helper.tblPlayers);
    }
    Navigator.pop(context, true);
  }

  void updateFirstName() {
    player.firstName = firstNameController.text;
  }

  void updateLastName() {
    player.lastName = lastNameController.text;
  }

  void updateGameTag() {
    player.gameTag = gameTagController.text;
  }
}
