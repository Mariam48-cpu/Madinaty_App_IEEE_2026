import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view/widgets/completed_group_view.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view/widgets/spin_button.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view/widgets/spin_wheel.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view/widgets/spin_wheel_header.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view/widgets/winner_bottom_sheet.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_state.dart';

class SpinWheelScreen extends StatefulWidget {
  final String groupId;
  final GroupMemberEntity currentUser;

  const SpinWheelScreen({
    super.key,
    required this.groupId,
    required this.currentUser,
  });

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  final StreamController<int> _selected = StreamController<int>();

  late final ConfettiController _confettiController;

  late final AnimationController _winnerAnimationController;

  late final Animation<double> _winnerScaleAnimation;

  bool _isSpinning = false;
  bool _winnerDialogShown = false;

  GroupCafePickEntity? _currentWinner;

  @override
  void initState() {
    super.initState();

    context.read<GroupCafeCubit>().watchGroup(widget.groupId);

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _winnerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _winnerScaleAnimation = CurvedAnimation(
      parent: _winnerAnimationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _selected.close();
    _confettiController.dispose();
    _winnerAnimationController.dispose();

    super.dispose();
  }

  List<GroupCafePickEntity> _getUniqueCafes(
    Map<String, List<GroupCafePickEntity>> picks,
  ) {
    final Map<String, GroupCafePickEntity> uniqueCafes = {};

    for (final userPicks in picks.values) {
      for (final cafe in userPicks) {
        uniqueCafes.putIfAbsent(cafe.cafeId, () => cafe);
      }
    }

    return uniqueCafes.values.toList();
  }

  List<GroupCafePickEntity> _getWeightedCafes(
    Map<String, List<GroupCafePickEntity>> picks,
  ) {
    final List<GroupCafePickEntity> weightedCafes = [];

    for (final userPicks in picks.values) {
      weightedCafes.addAll(userPicks);
    }

    return weightedCafes;
  }

  GroupCafePickEntity? _findCafeById(
    Map<String, List<GroupCafePickEntity>> picks,
    String? cafeId,
  ) {
    if (cafeId == null || cafeId.isEmpty) {
      return null;
    }

    for (final userPicks in picks.values) {
      for (final cafe in userPicks) {
        if (cafe.cafeId == cafeId) {
          return cafe;
        }
      }
    }

    return null;
  }

  List<String> _getPickedBy(
    Map<String, List<GroupCafePickEntity>> picks,
    GroupCafeEntity group,
    String cafeId,
  ) {
    final List<String> names = [];

    for (final member in group.members) {
      final memberPicks = picks[member.userId] ?? [];

      final picked = memberPicks.any((cafe) => cafe.cafeId == cafeId);

      if (picked) {
        names.add(member.name);
      }
    }

    return names;
  }

  Future<void> _spin(
    GroupCafeEntity group,
    Map<String, List<GroupCafePickEntity>> picks,
  ) async {
    if (_isSpinning || _winnerDialogShown) {
      return;
    }

    if (group.creatorId != widget.currentUser.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocale.onlyCreatorCanSpinError.getString(context)),
        ),
      );

      return;
    }

    final uniqueCafes = _getUniqueCafes(picks);

    final weightedCafes = _getWeightedCafes(picks);

    if (uniqueCafes.isEmpty || weightedCafes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocale.noCafesAvailableSpinError.getString(context)),
        ),
      );

      return;
    }

    setState(() {
      _isSpinning = true;
    });

    try {
      final random = Random();

      final randomPick = weightedCafes[random.nextInt(weightedCafes.length)];

      final winnerIndex = uniqueCafes.indexWhere(
        (cafe) => cafe.cafeId == randomPick.cafeId,
      );

      if (winnerIndex == -1) {
        setState(() {
          _isSpinning = false;
        });

        return;
      }

      _selected.add(winnerIndex);

      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) {
        return;
      }

      await context.read<GroupCafeCubit>().spin(
        groupId: widget.groupId,
        winnerCafeId: randomPick.cafeId,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _isSpinning = false;
        _winnerDialogShown = true;
        _currentWinner = randomPick;
      });

      _confettiController.play();

      _winnerAnimationController.forward();

      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) {
        return;
      }

      _showWinnerCelebration(group, picks, randomPick);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSpinning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocale.errorPrefix.getString(context)} $e'),
        ),
      );
    }
  }

  void _showWinnerCelebration(
    GroupCafeEntity group,
    Map<String, List<GroupCafePickEntity>> picks,
    GroupCafePickEntity winner,
  ) {
    final pickedBy = _getPickedBy(picks, group, winner.cafeId);

    WinnerBottomSheet.show(
      context: context,
      winner: winner,
      pickedBy: pickedBy,
      confettiController: _confettiController,
      winnerScaleAnimation: _winnerScaleAnimation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocale.chooseYourCafeTitle.getString(context)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),

      body: BlocBuilder<GroupCafeCubit, GroupCafeState>(
        builder: (context, state) {
          if (state is GroupCafeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupCafeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 55,
                      color: Colors.redAccent,
                    ),

                    const SizedBox(height: 15),

                    Text(state.message, textAlign: TextAlign.center),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        context.read<GroupCafeCubit>().watchGroup(
                          widget.groupId,
                        );
                      },
                      child: Text(AppLocale.tryAgainBtn.getString(context)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! GroupCafeLoaded) {
            return Center(
              child: Text(AppLocale.noGroupDataError.getString(context)),
            );
          }

          final group = state.group;
          final picks = state.picks;

          final uniqueCafes = _getUniqueCafes(picks);

          if (group.status == GroupCafeStatus.completed &&
              group.winnerCafeId != null) {
            final winner = _findCafeById(picks, group.winnerCafeId);

            if (winner == null) {
              return Center(
                child: Text(
                  AppLocale.winnerDataNotAvailable.getString(context),
                ),
              );
            }

            final pickedBy = _getPickedBy(picks, group, winner.cafeId);

            return CompletedGroupView(
              winner: winner,
              pickedBy: pickedBy,
              confettiController: _confettiController,
            );
          }

          if (uniqueCafes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppLocale.noCafesSelectedYet.getString(context),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                SpinWheelHeader(cafeCount: uniqueCafes.length),

                const SizedBox(height: 8),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: SpinWheel(cafes: uniqueCafes, selected: _selected),
                    ),
                  ),
                ),

                SpinButton(
                  isSpinning: _isSpinning,
                  onPressed: () {
                    _spin(group, picks);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
