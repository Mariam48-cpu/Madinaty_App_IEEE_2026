import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_state.dart';
import 'group_room_screen.dart';

class GroupCafeHomeScreen extends StatefulWidget {
  const GroupCafeHomeScreen({super.key});

  @override
  State<GroupCafeHomeScreen> createState() => _GroupCafeHomeScreenState();
}

class _GroupCafeHomeScreenState extends State<GroupCafeHomeScreen> {
  final _groupNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _isLoadingUser = false;

  GroupMemberEntity? _currentMember;

  @override
  void initState() {
    super.initState();
    _loadCurrentMember();
  }

  Future<void> _loadCurrentMember() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return;
    }

    setState(() {
      _isLoadingUser = true;
    });

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      String name = '';

      String? imageUrl;

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        name = (data['username'] ?? '').toString().trim();

        if (name.isEmpty) {
          name = (data['name'] ?? '').toString().trim();
        }

        imageUrl = data['profileImageUrl']?.toString();
      }

      if (name.isEmpty) {
        name = firebaseUser.displayName?.trim() ?? '';
      }

      if (name.isEmpty) {
        name = 'User';
      }

      imageUrl ??= firebaseUser.photoURL;

      if (!mounted) return;

      setState(() {
        _currentMember = GroupMemberEntity(
          userId: firebaseUser.uid,
          name: name,
          imageUrl: imageUrl,
        );

        _isLoadingUser = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _currentMember = GroupMemberEntity(
          userId: firebaseUser.uid,
          name: firebaseUser.displayName?.trim().isNotEmpty == true
              ? firebaseUser.displayName!.trim()
              : 'User',
          imageUrl: firebaseUser.photoURL,
        );

        _isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _inviteCodeController.dispose();

    super.dispose();
  }

  Future<void> _createGroup() async {
    final groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );

      return;
    }

    final member = _currentMember;

    if (member == null) {
      return;
    }

    final cubit = context.read<GroupCafeCubit>();

    final groupId = await cubit.createGroup(
      groupName: groupName,
      creator: member,
    );

    if (!mounted || groupId == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: GroupRoomScreen(groupId: groupId, currentUser: member),
        ),
      ),
    );
  }

  Future<void> _joinGroup() async {
    final inviteCode = _inviteCodeController.text.trim().toUpperCase();

    if (inviteCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the invite code')),
      );

      return;
    }

    final member = _currentMember;

    if (member == null) {
      return;
    }

    final cubit = context.read<GroupCafeCubit>();

    final groupId = await cubit.joinGroup(
      inviteCode: inviteCode,
      member: member,
    );

    if (!mounted || groupId == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: GroupRoomScreen(groupId: groupId, currentUser: member),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCafeCubit, GroupCafeState>(
      listener: (context, state) {
        if (state is GroupCafeError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Plan With Friends',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        body: _isLoadingUser
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'خطط خروجة مع أصحابك 🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'اختاروا الكافيهات مع بعض وسيبوا القرار النهائي للعجلة 🎡',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الجروب',
                        hintText: 'Friday Coffee',
                        prefixIcon: const Icon(Icons.groups_outlined),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _createGroup,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text(
                          'اعمل جروب جديد',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 28),

                    TextField(
                      controller: _inviteCodeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: 'كود الدعوة',
                        hintText: 'ABC123',
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _joinGroup,
                        icon: const Icon(Icons.login_rounded),
                        label: const Text(
                          'انضم لجروب',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'إزاي بتشتغل؟',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: 18),

                          _Step(
                            number: '1',
                            title: 'اعمل جروب',
                            description: 'أنشئ جروب وشارك كود الدعوة مع أصحابك',
                          ),

                          _Step(
                            number: '2',
                            title: 'كل واحد يختار',
                            description: 'كل شخص يختار من 2 لـ 3 كافيهات',
                          ),

                          _Step(
                            number: '3',
                            title: 'العجلة تقرر',
                            description:
                                'لما الكل يخلص، العجلة تختار الكافيه الفائز 🎡',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _Step({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
