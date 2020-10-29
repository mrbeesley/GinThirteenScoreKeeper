import 'package:flutter/material.dart';
import 'package:ginthirteen_app/components/drawer_menu.dart';

import 'game_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Gin 13 Scorecard"),
      ),
      drawer: DrawerMenu(),
      body: GameListScreen()
    );
  }
}
