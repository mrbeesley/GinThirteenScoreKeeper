import 'dart:convert';
import 'dart:math';
import 'package:ginthirteen_app/model/game.dart';
import 'package:intl/intl.dart';

class GameMock {
  final _random = new Random();

  List<Game> getMockData() {
    var mockData = List<Game>();
    mockData.add(_createGame('Lake Game', 'Beez Knees', 1));
    mockData.add(_createGame('Lake Game Night', 'Jess', 2));
    mockData.add(_createGame('Home Game', 'Bear', 3));
    mockData.add(_createGame('Best Game', 'Emieland', 4));
    mockData.add(_createGame('Best Game 1', 'CEO', 5));
    mockData.add(_createGame('I win', 'Beez Knees', 1));
    mockData.add(_createGame('win again', 'Beez Knees', 1));
    mockData.add(_createGame('all i do is win', 'Beez Knees', 1));
    mockData.add(_createGame('win win win', 'Beez Knees', 1));
    return mockData;
  }

  Game _createGame(String name, String winner, int id) {
    return Game(
        name,
        new DateFormat.yMd().format(DateTime.now().subtract(Duration(days: 2))),
        new DateFormat.yMd().format(DateTime.now()),
        13,
        winner,
        id);
  }
}
