import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../../domain/entities/group_cafe_entity.dart';
import '../../view_model/group_cafe_picker_cubit.dart';
import '../../view_model/group_cafe_picker_state.dart';

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

class _SpinWheelScreenState extends State<SpinWheelScreen> {
  final StreamController<int> _selected = StreamController<int>();

  bool _isSpinning = false;
  bool _winnerDialogShown = false;

  @override
  void initState() {
    super.initState();

    context.read<GroupCafeCubit>().watchGroup(widget.groupId);
  }

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  // ============================================================
  // GET UNIQUE CAFES
  // ============================================================

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

  // ============================================================
  // GET WEIGHTED CAFES
  // ============================================================

  List<GroupCafePickEntity> _getWeightedCafes(
    Map<String, List<GroupCafePickEntity>> picks,
  ) {
    final List<GroupCafePickEntity> weightedCafes = [];

    for (final userPicks in picks.values) {
      weightedCafes.addAll(userPicks);
    }

    return weightedCafes;
  }

  // ============================================================
  // FIND CAFE BY ID
  // ============================================================

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

  // ============================================================
  // GET MEMBERS WHO PICKED THE CAFE
  // ============================================================

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

  // ============================================================
  // SPIN
  // ============================================================

  Future<void> _spin(
    GroupCafeEntity group,
    Map<String, List<GroupCafePickEntity>> picks,
  ) async {
    if (_isSpinning || _winnerDialogShown) {
      return;
    }

    // Only creator can spin.
    if (group.creatorId != widget.currentUser.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only the group creator can spin the wheel.'),
        ),
      );

      return;
    }

    final uniqueCafes = _getUniqueCafes(picks);
    final weightedCafes = _getWeightedCafes(picks);

    if (uniqueCafes.isEmpty || weightedCafes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No cafe choices are available.')),
      );

      return;
    }

    setState(() {
      _isSpinning = true;
    });

    try {
      // ========================================================
      // WEIGHTED RANDOM
      // ========================================================
      //
      // If a cafe was picked by 3 users,
      // it appears 3 times in weightedCafes.
      //
      // So it gets a higher probability of winning.
      // ========================================================

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

      // ========================================================
      // START WHEEL ANIMATION
      // ========================================================

      _selected.add(winnerIndex);

      // Give the wheel enough time to finish its animation.
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) {
        return;
      }

      // ========================================================
      // SAVE WINNER TO FIREBASE
      // ========================================================

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
      });

      // Small delay so the wheel finishes visually.
      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) {
        return;
      }

      _showWinnerDialog(group, picks, randomPick);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSpinning = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    }
  }

  // ============================================================
  // WINNER DIALOG
  // ============================================================

  void _showWinnerDialog(
    GroupCafeEntity group,
    Map<String, List<GroupCafePickEntity>> picks,
    GroupCafePickEntity winner,
  ) {
    final pickedBy = _getPickedBy(picks, group, winner.cafeId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ------------------------------------------------
                  // HANDLE
                  // ------------------------------------------------
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------
                  // TITLE
                  // ------------------------------------------------
                  const Text(
                    '🎉 We Have a Winner!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // IMAGE
                  // ------------------------------------------------
                  if (winner.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        winner.imageUrl,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      ),
                    )
                  else
                    _buildImagePlaceholder(),

                  const SizedBox(height: 18),

                  // ------------------------------------------------
                  // CAFE NAME
                  // ------------------------------------------------
                  Text(
                    winner.cafeName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------
                  // RATING
                  // ------------------------------------------------
                  if (winner.rating > 0)
                    Text(
                      '⭐ ${winner.rating.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 15),
                    ),

                  // ------------------------------------------------
                  // ADDRESS
                  // ------------------------------------------------
                  if (winner.address.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      winner.address,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  // ------------------------------------------------
                  // PICKED BY
                  // ------------------------------------------------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Picked by',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (pickedBy.isEmpty)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Group members'),
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pickedBy.map((name) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 25),

                  // ------------------------------------------------
                  // DONE
                  // ------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Done 🎉',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: Icon(Icons.local_cafe_rounded, size: 60)),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spin The Wheel 🎡'), centerTitle: true),
      body: BlocBuilder<GroupCafeCubit, GroupCafeState>(
        builder: (context, state) {
          // ------------------------------------------------------
          // LOADING
          // ------------------------------------------------------

          if (state is GroupCafeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ------------------------------------------------------
          // ERROR
          // ------------------------------------------------------

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
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ------------------------------------------------------
          // NO DATA
          // ------------------------------------------------------

          if (state is! GroupCafeLoaded) {
            return const Center(child: Text('No group data available.'));
          }

          final group = state.group;
          final picks = state.picks;

          final uniqueCafes = _getUniqueCafes(picks);

          // ------------------------------------------------------
          // ALREADY COMPLETED
          // ------------------------------------------------------

          if (group.status == GroupCafeStatus.completed &&
              group.winnerCafeId != null) {
            final winner = _findCafeById(picks, group.winnerCafeId);

            if (winner == null) {
              return const Center(child: Text('Winner data is not available.'));
            }

            return _buildCompletedView(group, picks, winner);
          }

          // ------------------------------------------------------
          // NO CAFES
          // ------------------------------------------------------

          if (uniqueCafes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No cafes have been selected yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // ------------------------------------------------------
          // WHEEL
          // ------------------------------------------------------

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // --------------------------------------------------
                // HEADER
                // --------------------------------------------------
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Let the wheel decide where you go! ☕🎡',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${uniqueCafes.length} cafes are in the wheel',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),

                const SizedBox(height: 20),

                // --------------------------------------------------
                // WHEEL
                // --------------------------------------------------
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FortuneWheel(
                        selected: _selected.stream,
                        animateFirst: false,
                        items: [
                          for (int i = 0; i < uniqueCafes.length; i++)
                            FortuneItem(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  uniqueCafes[i].cafeName,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --------------------------------------------------
                // SPIN BUTTON
                // --------------------------------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isSpinning ? null : () => _spin(group, picks),
                      icon: Icon(
                        _isSpinning
                            ? Icons.hourglass_top_rounded
                            : Icons.casino_rounded,
                      ),
                      label: Text(
                        _isSpinning ? 'Spinning...' : 'Spin The Wheel',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // COMPLETED VIEW
  // ============================================================

  Widget _buildCompletedView(
    GroupCafeEntity group,
    Map<String, List<GroupCafePickEntity>> picks,
    GroupCafePickEntity winner,
  ) {
    final pickedBy = _getPickedBy(picks, group, winner.cafeId);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ----------------------------------------------------
            // TITLE
            // ----------------------------------------------------
            const Text(
              '🎉 The Winner',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // IMAGE
            // ----------------------------------------------------
            if (winner.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  winner.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                ),
              )
            else
              _buildImagePlaceholder(),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // NAME
            // ----------------------------------------------------
            Text(
              winner.cafeName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // ----------------------------------------------------
            // RATING
            // ----------------------------------------------------
            if (winner.rating > 0)
              Text(
                '⭐ ${winner.rating.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16),
              ),

            // ----------------------------------------------------
            // ADDRESS
            // ----------------------------------------------------
            if (winner.address.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                winner.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],

            const SizedBox(height: 25),

            // ----------------------------------------------------
            // PICKED BY
            // ----------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                children: [
                  const Text(
                    'Picked by',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pickedBy.isEmpty ? 'Group members' : pickedBy.join(' • '),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------------------------------
            // BACK
            // ----------------------------------------------------
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Group',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
