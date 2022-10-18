import 'dart:convert';
import 'dart:io';

import 'package:avalon/models/player.dart';
import 'package:avalon/models/role.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

import '../models/rule.dart';

class RuleService {
  static final RuleService _instance = RuleService._internal();

  factory RuleService() => _instance;

  RuleService._internal();

  final List<Rule> rules = [];

  Future<List<dynamic>> readJson() async {
    rules.clear();
    var file = await _localFile;

    var input = await file.readAsString();

    List<Map> listMap = List<Map>.from(jsonDecode(input));

    for (var e in listMap) {
      rules.add(Rule.fromJson(e));
    }

    return rules;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String rootPath = "resources/rules.json";
    if (Platform.isWindows) {
      return File(rootPath);
    } else if (Platform.isAndroid) {
      var file = File("$path/rules.json");

      if (!file.existsSync()) {
        var json = await rootBundle.loadString(rootPath);
        var file = await File('$path/rules.json').create(recursive: true);
        file.writeAsString(json);
        return file;
      }

      return File("$path/rules.json");
    }

    throw Exception();
  }

  String showRequiredPlayerCount(List<Role> roles, List<Player> players) {
    var msg = "";

    var lenActivePlayers = players.where((element) => element.isActive).length;

    if (lenActivePlayers == 0) return msg;

    // check evil count?
    var lenSpecialGood = 0;
    var lenSpecialEvil = 0;
    for (var role in roles) {
      if (!role.isActive! || !role.isUnique!) continue;

      if (role.allegiance == 0) {
        lenSpecialGood += 1;
      } else if (role.allegiance == 1) {
        lenSpecialEvil += 1;
      }
    }

    int minPlayers = 0;
    int maxPlayers = 0;
    var appliedRule = null;

    for (var rule in rules) {
      if (rule.totalPlayers == lenActivePlayers) {
        appliedRule = rule;
      }

      if (rule.good! < lenSpecialGood || rule.evil! < lenSpecialEvil) {
        continue;
      }

      if (minPlayers == 0) {
        minPlayers = rule.totalPlayers!;
      }

      maxPlayers = rule.totalPlayers!;

      if (rule.evil! > lenSpecialEvil) {
        break;
      }
    }

    if (minPlayers == 0) {
      msg += "Too many special roles. Try reducing some";
      return msg;
    }

    if (minPlayers == maxPlayers) {
      msg += "Min Player Count = $minPlayers";
    } else {
      msg += "Min-Max Player Count = $minPlayers - $maxPlayers";
    }
    msg += "\nCurrent Player Count = $lenActivePlayers";
    msg += "\nGood:Evil ratio =  ${appliedRule.good}:${appliedRule.evil}";
    return msg;
  }
}
