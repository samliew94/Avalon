import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:recase/recase.dart';

import '../models/player.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

import 'dart:io' show Platform;

class PlayerService {
  static final PlayerService _instance = PlayerService._internal();

  factory PlayerService() => _instance;

  PlayerService._internal();

  final List<Player> players = [];
  final random = Random();

  Future<List<Player>> readJson() async {
    players.clear();

    var file = await _localFile;

    var input = await file.readAsString();

    var temp = List<Map<String, dynamic>>.from(jsonDecode(input));

    for (var element in temp) {
      var player = Player.fromJson(element);
      players.add(player);
    }

    return players;
  }

  Future<List<Player>> waitUntilPlayersDataReady() async {
    while (players.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 250));
    }

    return players;
  }

  void savePlayer() async {
    for (var element in players) {
      element.roleCode = "";
      element.isSeenRole = false;
    }
    String json = jsonEncode(players);

    final file = await _localFile;

    file.writeAsString(json);

    print("saving players json file done");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String rootPath = "resources/players.json";
    if (Platform.isWindows) {
      return File(rootPath);
    } else if (Platform.isAndroid) {
      var file = File("$path/players.json");

      if (!file.existsSync()) {
        var json = await rootBundle.loadString(rootPath);
        var file = await File('$path/players.json').create(recursive: true);
        file.writeAsString(json);
        return file;
      }

      return File("$path/players.json");
    }

    throw Exception();
  }

  Map editPlayer(String editPlayerName, Player editPlayer) {
    var res = {};
    res["hasError"] = false;

    if (editPlayerName.trim().isEmpty) {
      res["hasError"] = true;
      res["error"] = "Player name cannot be empty";
      return res;
    }

    Player? player = players.firstWhereOrNull((e) =>
        e != editPlayer &&
        e.playerName!.toLowerCase() == editPlayerName.toLowerCase());

    if (player != null) {
      res["hasError"] = true;
      res["error"] = "Duplicate Player Name \"$editPlayerName\"";
      return res;
    }

    editPlayerName = ReCase(editPlayerName).titleCase;

    editPlayer.playerName = editPlayerName;

    return res;
  }

  Map addPlayer(String newPlayerName) {
    var res = {};
    res["hasError"] = false;

    if (newPlayerName.trim().isEmpty) {
      res["hasError"] = true;
      res["error"] = "Player name cannot be empty";
      return res;
    }

    int lenActivePlayers = players.where((element) => element.isActive).length;

    if (lenActivePlayers >= 10) {
      res["hasError"] = true;
      res["error"] = "Too many players ($lenActivePlayers).Max is 10";
      return res;
    }

    Player? player = players.firstWhereOrNull((element) =>
        element.playerName!.toLowerCase() == newPlayerName.toLowerCase());

    if (player != null) {
      res["hasError"] = true;
      res["error"] = "Duplicate Player Name \"$newPlayerName\"";
      return res;
    }

    newPlayerName = ReCase(newPlayerName).titleCase;

    player = Player(playerName: newPlayerName);
    players.add(player);

    return res;
  }

  void removePlayer(Player player) => players.remove(player);

  List<Player> getActivePlayers() => players.where((e) => e.isActive).toList();

  Map isTooManyActivePlayers() {
    var res = {};
    res["hasError"] = false;

    int lenActivePlayers = getActivePlayers().length;

    if (lenActivePlayers + 1 > 10) {
      res["hasError"] = true;
      res["error"] = "Too many active players ($lenActivePlayers).\n Max 10";
      return res;
    }

    return res;
  }
}
