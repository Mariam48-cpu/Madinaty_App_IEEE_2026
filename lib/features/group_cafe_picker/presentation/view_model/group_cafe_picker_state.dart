import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

abstract class GroupCafeState {
  const GroupCafeState();
}
class GroupCafeInitial extends GroupCafeState {
  const GroupCafeInitial();
}

class GroupCafeLoading extends GroupCafeState {
  const GroupCafeLoading();
}

class GroupCafeError extends GroupCafeState {
  final String message;

  const GroupCafeError(this.message);
}

class GroupCafeLoaded extends GroupCafeState {
  final GroupCafeEntity group;
  final Map<String, List<GroupCafePickEntity>> picks;

  const GroupCafeLoaded({required this.group, required this.picks});
}
