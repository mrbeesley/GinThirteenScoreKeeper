import 'dart:convert';
import 'dart:math';
import 'package:ginthirteen_app/model/player.dart';
import 'package:intl/intl.dart';

class PlayerMock {
  final _random = new Random();

  List<Player> getMockData() {
    var mockData = new List<Player>();
    mockData.add(_createMockPlayer("Michael", "Beesley", "Beez Knees"));
    mockData.add(_createMockPlayer("Jessica", "Beesley", "Jess"));
    mockData.add(_createMockPlayer("Noah", "Beesley", "Bear"));
    mockData.add(_createMockPlayer("Emelia", "Beesley", "Emieland"));
    mockData.add(_createMockPlayer("Estella", "Beesley", "CEO"));
    mockData.add(_createMockPlayer("Roger", "Beesley", "Gramps"));
    mockData.add(_createMockPlayer("Virginia", "Beesley", "Gigi"));
    mockData.add(_createMockPlayer("Chris", "Beesley", "CBeez"));
    return mockData;
  }

  Player _createMockPlayer(String firstName, lastName, gameTag) {
    dynamic o = {
      "firstName": firstName,
      "lastName": lastName,
      "gameTag": gameTag,
      "playerSince": new DateFormat.yMd().format(DateTime.now()),
      "avgScore": _random.nextInt(150) + 50,
      "gamesPlayed": _random.nextInt(30),
      "winPercent": _random.nextInt(99) + 1,
      "winStreak": _random.nextInt(10),
      "scoreHistory": jsonEncode(_generateMockScoreHistory())
    };
    return Player.fromObject(o);
  }

  List<int> _generateMockScoreHistory() {
    var ret = List<int>();
    for (int i = 0; i < 14; i++) {
      ret.add(_random.nextInt(60));
    }
    return ret;
  }
}
