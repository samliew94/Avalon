import 'package:avalon/services/game_service.dart';
import 'package:avalon/services/roles_service.dart';
import 'package:avalon/services/rules_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/player_service.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final ruleService = RuleService();

  final roleService = RoleService();
  final roles = RoleService().roles;

  final playerService = PlayerService();
  final players = PlayerService().players;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Roles'),
        ),
        body: ListView.builder(
          itemCount: roles.length,
          itemBuilder: (context, index) {
            var role = roles[index];

            return Card(
              child: CheckboxListTile(
                title: Text(
                  role.roleTitle!,
                  style: Theme.of(context).textTheme.headline5!.apply(
                      color: role.allegiance == 0 ? Colors.blue : Colors.red),
                ),
                value: (role.isActive ?? false),
                onChanged: !role.isCanEdit!
                    ? null
                    : (value) {
                        setState(() {
                          role.isActive = value;

                          var res = ruleService.showRequiredPlayerCount(
                              roles, players);

                          if (res.isNotEmpty) {
                            var snackBar = SnackBar(
                              content: Text(res),
                              duration: const Duration(seconds: 4),
                            );
                            var scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            scaffoldMessenger.hideCurrentSnackBar();
                            scaffoldMessenger.showSnackBar(snackBar);
                          }
                        });
                      },
              ),
            );
          },
        ));
  }
}
