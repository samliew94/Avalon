import 'dart:math';

import 'package:avalon/services/player_service.dart';
import 'package:avalon/services/rules_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import 'roles_service.dart';

class GameService {
  static final GameService _instance = GameService._internal();

  factory GameService() {
    return _instance;
  }

  GameService._internal();

  final playerService = PlayerService();
  final roleService = RoleService();
  final ruleService = RuleService();

  final players = PlayerService().players;
  final roles = RoleService().roles;
  final rules = RuleService().rules;

  bool _isGameStart = false;

  var _random = Random();

  Map validateGameRules() {
    var res = {};
    res["hasError"] = false;

    int len = players.where((e) => e.isActive).length;

    if (len < 5) {
      res["hasError"] = true;
      res["error"] = "Not enough players. Minimum is 5";
      return res;
    }

    var rule = rules.firstWhere((e) =>
        e.totalPlayers == players.where((element) => element.isActive).length);

    var lenGood = rule.good!;
    var lenEvil = rule.evil!;
    var lenSpecialGood = 0;
    var lenSpecialEvil = 0;
    for (var e in roles) {
      if (!e.isActive! || !e.isUnique!) {
        continue;
      }

      if (e.allegiance == 0) {
        lenSpecialGood += 1;
      } else if (e.allegiance == 1) {
        lenSpecialEvil += 1;
      }
    }

    if (lenSpecialGood > lenGood) {
      res["hasError"] = true;
      res["error"] = "Too many special Goods";
      return res;
    }

    if (lenSpecialEvil > lenEvil) {
      res["hasError"] = true;
      res["error"] = "Too many special Evils";
      return res;
    }

    res["extra"] = "Ratio of Good : Evil is\n$lenGood:$lenEvil";
    return res;
  }

  void resetGame() {
    _isGameStart = false;
  }

  Future<Map> assignRandomRoles() async {
    var res = {};
    res["hasError"] = false;
    res["isGameStart"] = false;

    if (_isGameStart) {
      return res;
    }

    _isGameStart = true;
    res["isGameStart"] = true;

    while (players.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 250));
    }

    List<Player> activePlayers =
        players.where((element) => element.isActive).toList();

    for (var e in activePlayers) {
      e.isSeenRole = false;
      e.roleCode = "";
    }

    var rule = rules.firstWhere((e) => e.totalPlayers == activePlayers.length);
    var evilCount = rule.evil!;

    var specialEvils = roles
        .where((e) => e.allegiance == 1 && e.isUnique! && e.isActive!)
        .toList();

    while (evilCount > 0) {
      var evilCode = "REG_EVIL";

      if (specialEvils.isNotEmpty) {
        var specialEvil = specialEvils[_random.nextInt(specialEvils.length)];
        evilCode = specialEvil.roleCode!;
        specialEvils.remove(specialEvil);
      }

      var activePlayer = activePlayers[_random.nextInt(activePlayers.length)];
      activePlayer.roleCode = evilCode;
      activePlayers.remove(activePlayer);

      evilCount -= 1;
    }

    var specialGoods = roles
        .where((e) => e.allegiance == 0 && e.isUnique! && e.isActive!)
        .toList();

    while (activePlayers.isNotEmpty) {
      var roleCode = "REG_GOOD";

      if (specialGoods.isNotEmpty) {
        var specialGood = specialGoods[_random.nextInt(specialGoods.length)];
        roleCode = specialGood.roleCode!;
        specialGoods.remove(specialGood);
      }

      var activePlayer = activePlayers[_random.nextInt(activePlayers.length)];
      activePlayer.roleCode = roleCode;
      activePlayers.remove(activePlayer);
    }

    for (var e in players) {
      print(e.toJson());
    }

    return res;
  }
}
