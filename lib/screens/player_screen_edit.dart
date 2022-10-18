import 'dart:math';

import 'package:avalon/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

import '../models/player.dart';
import 'alert.dart';

class EditPlayerWindow extends StatefulWidget {
  final Player editedPlayer;

  const EditPlayerWindow(this.editedPlayer, {Key? key}) : super(key: key);

  @override
  State<EditPlayerWindow> createState() => _EditPlayerWindowState();
}

class _EditPlayerWindowState extends State<EditPlayerWindow> {
  final myController = TextEditingController();
  final playerService = PlayerService();

  void showSnackBar(context, msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final editedPlayer = widget.editedPlayer;

    myController.text = editedPlayer.playerName!;

    return AlertDialog(
      title: Text('Edit ${editedPlayer.playerName}',
          style: Theme.of(context).textTheme.headline5),
      content: TextField(
        controller: myController,
        autofocus: true,
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            var res = playerService.editPlayer(myController.text, editedPlayer);

            if (res["hasError"]) {
              Alert(context).show("Error", res["error"]);
              return;
            }

            Navigator.pop(context);
          },
          child: Text('OK', style: Theme.of(context).textTheme.headline5),
        ),
      ],
    );
  }
}
