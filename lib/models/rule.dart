class Rule {
  int? totalPlayers;
  int? good;
  int? evil;

  Rule({this.totalPlayers, this.good, this.evil});

  Rule.fromJson(Map<dynamic, dynamic> json) {
    totalPlayers = json['total_players'];
    good = json['good'];
    evil = json['evil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total_players'] = totalPlayers;
    data['good'] = good;
    data['evil'] = evil;
    return data;
  }
}
