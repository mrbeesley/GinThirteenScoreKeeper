import 'package:flutter/material.dart';
import 'package:ginthirteen_app/screens/home_screen.dart';
import 'package:ginthirteen_app/screens/player_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/players': (context) => PlayerScreen(),
      },
    );
  }
}
