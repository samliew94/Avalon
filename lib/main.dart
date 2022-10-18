import 'dart:io';

import 'package:avalon/services/roles_service.dart';
import 'package:avalon/services/rules_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'screens/home.dart';
import 'services/player_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> initializeDependencies() async {
    await PlayerService().readJson();
    await RoleService().readJson();
    await RuleService().readJson();

    return true;
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.cormorantGaramondTextTheme(baseTheme.textTheme),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDependencies(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Avalon',
            theme: ThemeData(textTheme: GoogleFonts.mysteryQuestTextTheme()),
            home: Scaffold(
                body: Center(
                    child: Text(
              "error ${snapshot.error}",
              textAlign: TextAlign.center,
            ))),
          );
        }

        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Avalon',
            theme: ThemeData(textTheme: GoogleFonts.mysteryQuestTextTheme()),
            home: const Home(),
          );
        }

        List<Widget> loadingBar = const <Widget>[
          SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Initializing Dependencies...'),
          ),
        ];
        return MaterialApp(
          title: 'Avalon',
          theme: ThemeData(textTheme: GoogleFonts.cormorantGaramondTextTheme()),
          home: Scaffold(
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: loadingBar),
            ),
          ),
        );
      },
    );

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<Players>(create: (_) => Players()),
    //     ChangeNotifierProvider<Roles>(create: (_) => Roles()),
    //   ],
    //   child: MaterialApp(
    //     title: 'Avalon',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const Home(),
    //   ),
    // );
  }
}
