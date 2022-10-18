import 'package:avalon/models/player.dart';
import 'package:avalon/screens/alert.dart';
import 'package:avalon/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'player_screen_add.dart';
import 'player_screen_edit.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final playerService = PlayerService();
  final players = PlayerService().players;

  @override
  Widget build(BuildContext context) {
    players.sort((a, b) => a.playerName!.compareTo(b.playerName!));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Players'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addPlayer(context),
          backgroundColor: Colors.green,
          child: const Icon(FontAwesomeIcons.plus),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            Player player = players[index];
            String playerName = player.playerName!;

            return Card(
              child: ListTile(
                onTap: () => editPlayer(context, player),
                title: Text(
                  playerName,
                  style: Theme.of(context).textTheme.headline5,
                ),
                trailing: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      print("removing.. $playerName");
                      players.removeWhere(
                          (element) => element.playerName == playerName);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: player.isActive,
                            onChanged: (value) {
                              if (value!) {
                                var res =
                                    playerService.isTooManyActivePlayers();

                                if (res["hasError"]) {
                                  Alert(context).show("Error", res["error"]);
                                  return;
                                }
                              }

                              setState(() {
                                player.isActive = value;
                              });
                            },
                          ),
                          const Icon(FontAwesomeIcons.circleMinus,
                              color: Colors.red),
                        ],
                      ),
                    )),
              ),
            );
          },
        ));
  }

  Future<void> addPlayer(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const AddPlayerWindow(),
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> editPlayer(BuildContext context, Player editedPlayer) async {
    await showDialog(
      context: context,
      builder: (context) => EditPlayerWindow(editedPlayer),
    );

    if (!mounted) return;

    setState(() {});
  }
}

// create a datasource
