import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/data/models/group_cafe_model.dart';

import '../../../domain/entities/group_cafe_entity.dart';
import '../../view_model/group_cafe_picker_cubit.dart';
import '../../view_model/group_cafe_picker_state.dart';

import 'cafe_picker_screen.dart';
import 'spin_wheel_screen.dart';

class GroupRoomScreen extends StatefulWidget {
  final String groupId;
  final GroupMemberEntity currentUser;

  const GroupRoomScreen({
    super.key,
    required this.groupId,
    required this.currentUser,
  });

  @override
  State<GroupRoomScreen> createState() => _GroupRoomScreenState();
}

class _GroupRoomScreenState extends State<GroupRoomScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GroupCafeCubit>().watchGroup(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Room'), centerTitle: true),
      body: BlocBuilder<GroupCafeCubit, GroupCafeState>(
        builder: (context, state) {
          if (state is GroupCafeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupCafeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
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

          if (state is! GroupCafeLoaded) {
            return const Center(child: Text('Group not found'));
          }

          final group = state.group;

          final isCreator = group.creatorId == widget.currentUser.userId;
          final currentMember = group.members.firstWhere(
            (member) => member.userId == widget.currentUser.userId,
            orElse: () => GroupMemberModel.fromEntity(widget.currentUser),
          );

          final everyoneReady =
              group.members.isNotEmpty &&
              group.members.every((member) => member.isReady);

          final isCompleted = group.status == GroupCafeStatus.completed;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =========================
                  // GROUP HEADER
                  // =========================
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.groups_rounded, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          group.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Plan your next coffee outing together ☕',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // INVITE CODE
                  // =========================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Invite Code',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                group.inviteCode,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.key_rounded, size: 28),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =========================
                  // MEMBERS TITLE
                  // =========================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${group.members.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Group Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =========================
                  // MEMBERS
                  // =========================
                  ...group.members.map((member) {
                    final isCurrentUser =
                        member.userId == widget.currentUser.userId;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.45),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                member.imageUrl != null &&
                                    member.imageUrl!.isNotEmpty
                                ? NetworkImage(member.imageUrl!)
                                : null,
                            child:
                                member.imageUrl == null ||
                                    member.imageUrl!.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCurrentUser
                                      ? '${member.name} (You)'
                                      : member.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member.isReady
                                      ? 'Ready ✓'
                                      : 'Choosing cafes...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: member.isReady
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: member.isReady
                                  ? Colors.green.withValues(alpha: 0.12)
                                  : Colors.orange.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              member.isReady
                                  ? Icons.check_rounded
                                  : Icons.hourglass_empty_rounded,
                              size: 18,
                              color: member.isReady
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // =========================
                  // COMPLETED
                  // =========================
                  if (isCompleted) ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.green.withValues(alpha: 0.10),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.celebration_rounded,
                            color: Colors.green,
                            size: 38,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'The winner has been selected! 🎉',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // =========================
                    // STATUS
                    // =========================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: everyoneReady
                            ? Colors.green.withValues(alpha: 0.10)
                            : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.08),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            everyoneReady
                                ? Icons.celebration_rounded
                                : Icons.info_outline_rounded,
                            color: everyoneReady
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              everyoneReady
                                  ? 'Everyone is ready! 🎉'
                                  : 'Waiting for everyone to finish choosing.',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // =========================
                    // CHOOSE CAFES
                    // =========================
                    if (!currentMember.isReady)
                      SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<DiscoveryCubit>(),
                                  child: CafePickerScreen(
                                    groupId: group.id,
                                    currentUser: currentMember,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.local_cafe_rounded),
                          label: const Text(
                            'Choose My Cafes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // =========================
                    // SPIN WHEEL
                    // =========================
                    if (everyoneReady && isCreator) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SpinWheelScreen(
                                  groupId: group.id,
                                  currentUser: currentMember,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.casino_rounded),
                          label: const Text(
                            'Spin The Wheel 🎡',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // =========================
                    // WAIT FOR CREATOR
                    // =========================
                    if (everyoneReady && !isCreator)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.hourglass_top_rounded, size: 30),
                            SizedBox(height: 8),
                            Text(
                              'Everyone is ready!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Waiting for the creator to spin the wheel 🎡',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
