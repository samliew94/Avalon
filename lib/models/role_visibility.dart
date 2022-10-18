import 'role.dart';

/// Available Roles:
/// 01 - REG_RED - sees REG_REG
/// 02 - REG_BLUE - sees nobody
/// 03 - MERLIN - sees REG_REG
/// 04 - MORGANA - sees REG_REG
/// 05 - PERCIVAL - sees MERLIN and MORGANA
/// 06 - MORDRED - sees REG_RED
class RoleVisibility {
  final int _roleVisibilityId;
  final Role _role;
  final Role _canSeeRole;

  RoleVisibility(this._roleVisibilityId, this._role, this._canSeeRole);
}
