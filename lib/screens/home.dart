import 'package:avalon/screens/alert.dart';
import 'package:avalon/screens/home_buttons.dart';
import 'package:avalon/screens/player_screen.dart';
import 'package:avalon/screens/roles_screen.dart';
import 'package:avalon/screens/select_player_screen.dart';
import 'package:avalon/services/game_service.dart';
import 'package:avalon/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/roles_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Home';

    final items = [
      HomeButtonItem(
          FontAwesomeIcons.peopleGroup,
          "Players",
          Colors.blue,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PlayerScreen()))),
      HomeButtonItem(
          FontAwesomeIcons.hatWizard,
          "Roles",
          Colors.purple,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RolesScreen())))
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PlayerService().savePlayer();
          RoleService().saveRoles();
          GameService().resetGame();

          var res = GameService().validateGameRules();

          if (res["hasError"]) {
            Alert(context).show("Uh oh!", "${res["error"]}");
            return;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SelectPlayerScreen()));
        },
        tooltip: 'Start Game',
        child: const Icon(
          FontAwesomeIcons.play,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];

              return Card(
                child: InkWell(
                  onTap: item.onClickCallback,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.iconData,
                          color: item.iconColor,
                          size: 48,
                        ),
                        Text(
                          item.title,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ]),
                ),
              );
            }),
      ),
    );
  }
}
