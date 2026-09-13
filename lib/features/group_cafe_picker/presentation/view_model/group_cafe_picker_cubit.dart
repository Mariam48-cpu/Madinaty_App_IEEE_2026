import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/use_cases/create_group_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/use_cases/join_group_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/use_cases/spin_group_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/use_cases/submit_group_picks_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/use_cases/watch_group_picks_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/use_cases/watch_group_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_state.dart';

@injectable
class GroupCafeCubit extends Cubit<GroupCafeState> {
  final CreateGroupUseCase createGroupUseCase;
  final JoinGroupUseCase joinGroupUseCase;
  final SubmitGroupPicksUseCase submitGroupPicksUseCase;
  final WatchGroupUseCase watchGroupUseCase;
  final WatchGroupPicksUseCase watchGroupPicksUseCase;
  final SpinGroupUseCase spinGroupUseCase;

  StreamSubscription? groupSubscription;
  StreamSubscription? picksSubscription;

  GroupCafeEntity? _currentGroup;

  Map<String, List<GroupCafePickEntity>> _currentPicks = {};

  GroupCafeCubit({
    required this.createGroupUseCase,
    required this.joinGroupUseCase,
    required this.submitGroupPicksUseCase,
    required this.watchGroupUseCase,
    required this.watchGroupPicksUseCase,
    required this.spinGroupUseCase,
  }) : super(GroupCafeInitial());

  Future<String?> createGroup({
    required String groupName,
    required GroupMemberEntity creator,
  }) async {
    try {
      emit(GroupCafeLoading());

      final groupId = await createGroupUseCase(
        groupName: groupName,
        creator: creator,
      );

      watchGroup(groupId);

      return groupId;
    } catch (e) {
      emit(GroupCafeError(e.toString()));

      return null;
    }
  }

  Future<String?> joinGroup({
    required String inviteCode,
    required GroupMemberEntity member,
  }) async {
    try {
      emit(GroupCafeLoading());

      final group = await joinGroupUseCase(
        inviteCode: inviteCode,
        member: member,
      );

      watchGroup(group.id);

      return group.id;
    } catch (e) {
      emit(GroupCafeError(e.toString()));

      return null;
    }
  }

  void watchGroup(String groupId) {
    groupSubscription?.cancel();
    picksSubscription?.cancel();

    groupSubscription = watchGroupUseCase(groupId).listen((group) {
      if (group == null) return;

      _currentGroup = group;

      emitLoaded();
    });

    picksSubscription = watchGroupPicksUseCase(groupId).listen((picks) {
      _currentPicks = picks;

      emitLoaded();
    });
  }

  void emitLoaded() {
    if (_currentGroup == null) return;

    emit(GroupCafeLoaded(group: _currentGroup!, picks: _currentPicks));
  }

  Future<void> submitPicks({
    required String groupId,
    required String userId,
    required List<GroupCafePickEntity> picks,
  }) async {
    try {
      await submitGroupPicksUseCase(
        groupId: groupId,
        userId: userId,
        picks: picks,
      );
    } catch (e) {
      emit(GroupCafeError(e.toString()));
    }
  }

  Future<void> spin({
    required String groupId,
    required String winnerCafeId,
  }) async {
    try {
      await spinGroupUseCase(groupId: groupId, winnerCafeId: winnerCafeId);
    } catch (e) {
      emit(GroupCafeError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    groupSubscription?.cancel();
    picksSubscription?.cancel();

    return super.close();
  }
}
