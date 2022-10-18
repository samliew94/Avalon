class Role {
  String? roleCode;
  List<String>? canSee;
  String? roleTitle;
  String? description;
  int? allegiance;
  bool? isCanEdit;
  bool? isActive;
  bool? isUnique;
  String? otherPlayerTitle;
  String? otherPlayerColor;

  Role({
    this.roleCode,
    this.canSee,
    this.roleTitle,
    this.description,
    this.allegiance,
    this.isCanEdit,
    this.isActive,
    this.isUnique,
    this.otherPlayerTitle,
    this.otherPlayerColor,
  });

  Role.fromJson(Map<dynamic, dynamic> json) {
    roleCode = json['role_code'];
    canSee = json['can_see'].cast<String>();
    roleTitle = json['role_title'];
    description = json['description'];
    allegiance = json['allegiance'];
    isCanEdit = json['is_can_edit'];
    isActive = json['is_active'];
    isUnique = json['is_unique'];
    otherPlayerTitle = json['other_player_title'];
    otherPlayerColor = json['other_player_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['role_code'] = roleCode;
    data['can_see'] = canSee;
    data['role_title'] = roleTitle;
    data['description'] = description;
    data['allegiance'] = allegiance;
    data['is_can_edit'] = isCanEdit;
    data['is_active'] = isActive;
    data['is_unique'] = isUnique;
    data['is_unique'] = isUnique;
    data['other_player_title'] = otherPlayerTitle;
    data['other_player_color'] = otherPlayerColor;

    return data;
  }
}
