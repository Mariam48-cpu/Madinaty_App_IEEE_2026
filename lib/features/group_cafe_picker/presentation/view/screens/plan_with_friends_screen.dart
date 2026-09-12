import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view/screens/group_cafe_home_screen.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/presentation/view_model/group_cafe_picker_cubit.dart';

class PlanWithFriendsScreen extends StatelessWidget {
  const PlanWithFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GroupCafeCubit>(),
      child: const GroupCafeHomeScreen(),
    );
  }
}
