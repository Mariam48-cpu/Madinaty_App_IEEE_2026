import 'package:equatable/equatable.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

abstract class GroupCafeState extends Equatable {
  const GroupCafeState();

  @override
  List<Object?> get props => [];
}

class GroupCafeInitial extends GroupCafeState {}

class GroupCafeLoading extends GroupCafeState {}

class GroupCafeError extends GroupCafeState {
  final String message;

  const GroupCafeError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupCafeLoaded extends GroupCafeState {
  final GroupCafeEntity group;

  final Map<String, List<GroupCafePickEntity>> picks;

  const GroupCafeLoaded({
    required this.group,
    required this.picks,
  });

  @override
  List<Object?> get props => [
        group,
        picks,
      ];
}