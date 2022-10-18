import 'package:avalon/screens/alert.dart';
import 'package:avalon/services/game_service.dart';
import 'package:avalon/services/player_service.dart';
import 'package:avalon/services/roles_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/player.dart';

class PlayerIdentityScreen extends StatefulWidget {
  final Player player;

  const PlayerIdentityScreen(this.player, {Key? key}) : super(key: key);

  @override
  State<PlayerIdentityScreen> createState() => _PlayerIdentityScreenState();
}

class _PlayerIdentityScreenState extends State<PlayerIdentityScreen> {
  final playerService = PlayerService();
  final roleService = RoleService();

  final players = PlayerService().players;
  final roles = RoleService().roles;

  final gameService = GameService();

  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    var player = widget.player;
    var playerName = widget.player.playerName!;
    var role = roles.firstWhere((e) => e.roleCode == widget.player.roleCode);
    var roleTitle = role.roleTitle;
    var roleDescription = role.description;

    var canSeeOtherPlayers = players
        .where((e) =>
            e.isActive && e != player && role.canSee!.contains(e.roleCode))
        .toList();

    final List<Widget> otherPlayerNames = [];
    for (var otherPlayer in canSeeOtherPlayers) {
      otherPlayerNames.add(Text(otherPlayer.playerName!,
          style: Theme.of(context).textTheme.headline5!.apply(
              color: role.otherPlayerColor == null
                  ? Colors.black
                  : Color(int.parse(role.otherPlayerColor!)))));
    }

    final List<Widget> playerInfo = [
      Text(
        playerName,
        style:
            Theme.of(context).textTheme.headline2!.apply(color: Colors.black),
      ),
      const SizedBox(height: 10),
      Text(roleTitle!,
          style: Theme.of(context).textTheme.headline4!.apply(
                color: role.allegiance! == 1 ? Colors.red : Colors.blue,
              )),
      Text(roleDescription!,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .apply(fontStyle: FontStyle.italic)),
      const SizedBox(
        height: 30,
      ),
      (role.otherPlayerTitle == null
          ? const SizedBox()
          : Text("${role.otherPlayerTitle}:",
              style: Theme.of(context).textTheme.headline5!))
    ];

    playerInfo.addAll(otherPlayerNames);

    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: InkWell(
              onTap: () {
                if (isFlipped) {
                  Navigator.pop(context);
                  return;
                }
                player.isSeenRole = true;

                setState(() {
                  isFlipped = true;
                });
              },
              child: Center(
                  child: isFlipped
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: playerInfo,
                        )
                      : Text(
                          "Tap to See",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .apply(color: Colors.black),
                        )),
            ),
          ),
        ));
  }
}
