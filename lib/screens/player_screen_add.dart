import 'package:avalon/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

import '../models/player.dart';

import 'dart:math';

import 'alert.dart';

class AddPlayerWindow extends StatefulWidget {
  const AddPlayerWindow({Key? key}) : super(key: key);

  @override
  State<AddPlayerWindow> createState() => _AddPlayerWindowState();
}

class _AddPlayerWindowState extends State<AddPlayerWindow> {
  final myController = TextEditingController();
  bool isPreferablyEvil = Random().nextBool();

  final rng = Random();

  final playerService = PlayerService();

  void showSnackBar(context, msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter Your Name',
        style: Theme.of(context).textTheme.headline5,
      ),
      content: TextField(
          controller: myController,
          autofocus: true,
          style: Theme.of(context).textTheme.headline5),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        TextButton(
          onPressed: () {
            var res = playerService.addPlayer(myController.text);

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
