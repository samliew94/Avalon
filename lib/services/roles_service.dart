import 'dart:convert';
import 'dart:io';

import 'package:avalon/services/rules_service.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/role.dart';

class RoleService {
  static final RoleService instance = RoleService._internal();

  factory RoleService() => instance;

  RoleService._internal();

  final List<Role> roles = [];

  Future<List<Role>> readJson() async {
    roles.clear();

    var file = await _localFile;

    var input = await file.readAsString();

    List<Map> listMap = List<Map>.from(jsonDecode(input));

    for (var e in listMap) {
      roles.add(Role.fromJson(e));
    }

    return roles;
  }

  void saveRoles() async {
    String json = jsonEncode(roles);

    final file = await _localFile;

    file.writeAsString(json);

    print("saving roles json file done");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String rootPath = "resources/roles.json";
    if (Platform.isWindows) {
      return File(rootPath);
    } else if (Platform.isAndroid) {
      var file = File("$path/roles.json");

      if (!file.existsSync()) {
        var json = await rootBundle.loadString(rootPath);
        var file = await File('$path/roles.json').create(recursive: true);
        file.writeAsString(json);
        return file;
      }

      return File("$path/roles.json");
    }

    throw Exception();
  }
}
