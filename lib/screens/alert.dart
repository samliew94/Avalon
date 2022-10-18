import 'package:flutter/material.dart';

class Alert {
  static final Alert _singleton = Alert._internal();
  Alert._internal();
  BuildContext? context;

  factory Alert(context) {
    _singleton.context = context;

    return _singleton;
  }

  Future show(title, msg) async {
    return showDialog(
      context: context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.headline5),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg, style: Theme.of(context).textTheme.headline6),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.headline5),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('OK', style: Theme.of(context).textTheme.headline5),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
