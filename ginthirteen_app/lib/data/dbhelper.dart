import 'package:ginthirteen_app/model/data_model.dart';
import 'package:ginthirteen_app/model/game.dart';
import 'package:ginthirteen_app/model/game_mock.dart';
import 'package:ginthirteen_app/model/player_mock.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ginthirteen_app/model/player.dart';
import 'package:ginthirteen_app/model/score_model.dart';

class DbHelper {
  // Use a singleton pattern, you only want one instance of this
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  // Table names
  String tblPlayers = 'players';
  String tblGame = 'games';
  String tblScores = 'scores';

  // db instance
  static Database _db;
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "ginthirteen.db";
    var dbGin = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbGin;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tblPlayers(" +
        "${PlayerFields.id} INTEGER PRIMARY KEY, " +
        "${PlayerFields.playerSince} TEXT, " +
        "${PlayerFields.firstName} TEXT, " +
        "${PlayerFields.lastName} TEXT, " +
        "${PlayerFields.gameTag} TEXT, " +
        "${PlayerFields.avgScore} int, " +
        "${PlayerFields.totalWins} int, " +
        "${PlayerFields.gamesPlayed} int, " +
        "${PlayerFields.winPercent} int, " +
        "${PlayerFields.winStreak} int)");

    await db.execute("CREATE TABLE $tblGame(" +
        "${GameFields.id} INTEGER PRIMARY KEY, " +
        "${GameFields.name} TEXT, " +
        "${GameFields.gameStarted} TEXT, " +
        "${GameFields.gameEnded} TEXT, " +
        "${GameFields.currentRound} int, " +
        "${GameFields.gameWinnerTag} TEXT, " +
        "${GameFields.gameWinnerId} int, " +
        "${GameFields.players} TEXT)");

    await db.execute("CREATE TABLE $tblScores("
        "${ScoreModelFields.id} INTEGER PRIMARY KEY, " +
        "${ScoreModelFields.gameId} int, " +
        "${ScoreModelFields.playerId} int, " +
        "${ScoreModelFields.round} int, " +
        "${ScoreModelFields.score} int, " +
        "${ScoreModelFields.runningScore} int)");

    // This is just for testing and needs to be removed for release
    await _seedMockPlayerData(db);
    await _seedGameData(db);
  }

  Future<int> insertData(DataModel data, String table) async {
    var db = await this.db;
    var result = await db.insert(table, data.toMap());
    return result;
  }

  Future<List> _getData(String table, String sortBy) async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $table ORDER BY $sortBy ASC");
    return result;
  }

  Future<List<Player>> getPlayers() async {
    List<Player> ret = List<Player>();
    var result = await _getData(tblPlayers, PlayerFields.winStreak);

    result.forEach((p) => ret.add(Player.fromObject(p)));
    return ret;
  }

  Future<List<Game>> getGames() async {
    List<Game> ret = List<Game>();
    var result = await _getData(tblGame, GameFields.id);

    result.forEach((p) => ret.add(Game.fromObject(p)));
    return ret;
  }

  Future<List<ScoreModel>> getScoresForGame(int gameId) async {
    List<ScoreModel> ret = List<ScoreModel>();
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblScores " + 
        "WHERE ${ScoreModelFields.gameId} = $gameId " +
        "ORDER BY ${ScoreModelFields.round} ASC, ${ScoreModelFields.runningScore} DESC");

    result.forEach((p) => ret.add(ScoreModel.fromObject(p)));
    return ret;
  }

  Future<List<ScoreModel>> getScoresForPlayer(int gameId, int playerId) async {
    List<ScoreModel> ret = List<ScoreModel>();
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblScores " + 
        "WHERE ${ScoreModelFields.gameId} = $gameId AND ${ScoreModelFields.playerId} = $playerId " +
        "ORDER BY ${ScoreModelFields.round} ASC, ${ScoreModelFields.runningScore} DESC");

    result.forEach((p) => ret.add(ScoreModel.fromObject(p)));
    return ret;
  }

  Future<int> getCount(String table) async {
    var db = await this.db;
    var result =
        Sqflite.firstIntValue(await db.rawQuery("SELECT count(*) FROM $table"));
    return result;
  }

  Future<int> updateData(
      DataModel data, String table, String colId, int id) async {
    var db = await this.db;
    var result = await db
        .update(table, data.toMap(), where: "$colId = ?", whereArgs: [id]);
    return result;
  }

  Future<int> deleteData(String table, String colId, int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $table WHERE $colId = $id");
    return result;
  }

  Future _seedMockPlayerData(Database db) async {
    var mockData = PlayerMock().getMockData();
    for (var item in mockData) {
      await db.insert(tblPlayers, item.toMap());
    }
  }

  Future _seedGameData(Database db) async {
    var mockData = GameMock().getMockData();
    for (var item in mockData) {
      await db.insert(tblGame, item.toMap());
    }
  }
}
