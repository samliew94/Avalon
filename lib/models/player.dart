import 'package:flutter/material.dart';

/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Player.fromJson(map);
*/
class Player {
  String? playerName;
  String roleCode = "";
  bool isSeenRole = false;
  bool isActive = true;

  Player({this.playerName});

  Player.fromJson(Map<String, dynamic> json) {
    playerName = json['player_name'];
    roleCode = json['role_code'];
    isSeenRole = json['is_seen_role'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['player_name'] = playerName;
    data['role_code'] = roleCode;
    data['is_seen_role'] = isSeenRole;
    data['is_active'] = isActive;
    return data;
  }
}
