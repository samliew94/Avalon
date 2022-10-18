import 'package:avalon/screens/alert.dart';
import 'package:avalon/screens/player_identity_screen.dart';
import 'package:avalon/services/game_service.dart';
import 'package:avalon/services/player_service.dart';
import 'package:avalon/services/roles_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/player.dart';

class SelectPlayerScreen extends StatefulWidget {
  const SelectPlayerScreen({Key? key}) : super(key: key);

  @override
  State<SelectPlayerScreen> createState() => _SelectPlayerScreenState();
}

class _SelectPlayerScreenState extends State<SelectPlayerScreen> {
  final playerService = PlayerService();
  final roleService = RoleService();

  final players = PlayerService().getActivePlayers();
  final roles = RoleService().roles;

  final gameService = GameService();

  Future<void> onTapped(BuildContext context, Player player) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerIdentityScreen(player)),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    players.sort((a, b) => a.playerName!.compareTo(b.playerName!));

    return WillPopScope(
      onWillPop: () async {
        var res = await Alert(context)
            .show("Info", "Going back resets the Game.\nClick OK to continue.");
        return res;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Reveal Self Identity'),
          ),
          body: FutureBuilder(
            future: gameService.assignRandomRoles(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child:
                        Text("Error at assignRandomRoles \n${snapshot.error}"));
              }

              if (!snapshot.hasData)
                return const Center(child: Text("wait..."));

              return ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  Player player = players[index];
                  String playerName = player.playerName!;

                  return Card(
                    child: ListTile(
                      onTap: (player.isSeenRole
                          ? null
                          : () => onTapped(context, player)),
                      title: Text(
                        playerName,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      trailing: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                              player.isSeenRole ? FontAwesomeIcons.check : null,
                              color: player.isSeenRole ? Colors.green : null)),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
