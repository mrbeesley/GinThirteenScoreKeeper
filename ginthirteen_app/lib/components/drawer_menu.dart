import 'package:flutter/material.dart';

const drawerTitle = 'Menu';

class DrawerMenu extends StatelessWidget {
  final lblHome = 'Home';
  final lblPlayers = 'Players';
  final lblGames = 'Games';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                drawerTitle,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text(lblHome),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          getLine(),
          ListTile(
            title: Text(lblPlayers),
            onTap: () => Navigator.pushReplacementNamed(context, '/players'),
          ),
        ],
      ),
    );
  }

  Widget getLine() {
    return SizedBox(
      height: 0.5,
      child: Container(
        color: Colors.grey,
      ),
    ); 
  }
}
