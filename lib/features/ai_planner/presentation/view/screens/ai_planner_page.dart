import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/localization/app_locale.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_toast.dart';

import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/entities/ai_plan_entity.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/repositories/ai_planner_repository.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/ai_hero.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/ai_planner_top_bar.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/mood_chips.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/plan_button.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/planner_controls_card.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/processing/processing_screen.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/prompt_field.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/quick_picks.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/result/result_screen.dart';

class AIPlannerPage extends StatefulWidget {
  const AIPlannerPage({super.key});

  @override
  State<AIPlannerPage> createState() => _AIPlannerPageState();
}

class _AIPlannerPageState extends State<AIPlannerPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final AIPlannerRepository _repository = GetIt.I<AIPlannerRepository>();

  final List<String> _interests = [];

  double _budget = 500;
  int _durationHours = 3;

  String? _selectedMood;
  String? _selectedOccasion;

  AIPlannerView _view = AIPlannerView.input;

  AIPlanEntity? _plan;
  String? _errorMessage;

  Timer? _processingTimer;
  int _processingStep = 0;

  late AnimationController _animationController;

  List<String> _getProcessingMessages(BuildContext context) => [
    AppLocale.aiProcessingStep1.getString(context),
    AppLocale.aiProcessingStep2.getString(context),
    AppLocale.aiProcessingStep3.getString(context),
    AppLocale.aiProcessingStep4.getString(context),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    _animationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _createPlan() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      _showMessage(AppLocale.aiInputEmptyPrompt.getString(context));
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _view = AIPlannerView.processing;
      _plan = null;
      _errorMessage = null;
      _processingStep = 0;
    });

    _startProcessingAnimation();

    try {
      final request = AIPlanRequestEntity(
        message: message,
        budget: _budget,
        durationHours: _durationHours,
        interests: List<String>.from(_interests),
        mood: _selectedMood,
        occasion: _selectedOccasion,
      );

      final plan = await _repository.createPlan(request);

      _processingTimer?.cancel();

      if (!mounted) return;

      setState(() {
        _plan = plan;
        _view = AIPlannerView.result;
      });
    } catch (e) {
      _processingTimer?.cancel();

      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _view = AIPlannerView.error;
      });
    }
  }

  void _startProcessingAnimation() {
    _processingTimer?.cancel();

    _processingTimer = Timer.periodic(
      const Duration(milliseconds: 1100),
          (_) {
        if (!mounted) return;
        final messages = _getProcessingMessages(context);
        if (_processingStep < messages.length - 1) {
          setState(() {
            _processingStep++;
          });
        }
      },
    );
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_interests.contains(interest)) {
        _interests.remove(interest);
      } else {
        _interests.add(interest);
      }
    });
  }

  void _startAgain() {
    setState(() {
      _view = AIPlannerView.input;
      _plan = null;
      _errorMessage = null;
      _processingStep = 0;
    });
  }

  void _showMessage(String message) {
    AppToast.showToast(
      context: context,
      title: AppLocale.toastError.getString(context),
      description: message,
      type: ToastificationType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _buildCurrentView(),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_view) {
      case AIPlannerView.input:
        return _buildInputScreen();

      case AIPlannerView.processing:
        return ProcessingScreen(
          animationController: _animationController,
          processingStep: _processingStep,
          processingMessages: _getProcessingMessages(context),
        );

      case AIPlannerView.result:
        return ResultScreen(
          plan: _plan!,
          onStartAgain: _startAgain,
        );

      case AIPlannerView.error:
        return _buildErrorScreen();
    }
  }

  Widget _buildInputScreen() {
    return SingleChildScrollView(
      key: const ValueKey('input'),
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AIPlannerTopBar(
            showBack: true,
            onBack: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24),
          AIHero(
            animationController: _animationController,
          ),
          const SizedBox(height: 26),
          Text(
            AppLocale.aiPlanPromptTitle.getString(context),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocale.aiPlanPromptSubtitle.getString(context),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          PromptField(
            controller: _messageController,
            onSubmitted: _createPlan,
          ),
          const SizedBox(height: 22),
          _buildSectionTitle(AppLocale.aiQuickPicks.getString(context)),
          const SizedBox(height: 12),
          QuickPicks(
            interests: _interests,
            onToggle: _toggleInterest,
            controller: _messageController,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(AppLocale.aiWhatsYourMood.getString(context)),
          const SizedBox(height: 12),
          MoodChips(
            selectedMood: _selectedMood,
            onMoodSelected: (mood) {
              setState(() {
                _selectedMood = mood;
              });
            },
          ),
          const SizedBox(height: 24),
          PlannerControlsCard(
            budget: _budget,
            durationHours: _durationHours,
            onBudgetChanged: (value) {
              setState(() {
                _budget = value;
              });
            },
            onDurationChanged: (value) {
              setState(() {
                _durationHours = value;
              });
            },
          ),
          const SizedBox(height: 26),
          PlanButton(
            onPressed: _createPlan,
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              AppLocale.aiPoweredBy.getString(context),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                color: Colors.red.shade400,
                size: 35,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              AppLocale.aiErrorTitle.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage ?? AppLocale.aiErrorGeneric.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _startAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  AppLocale.retry.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

enum AIPlannerView {
  input,
  processing,
  result,
  error,
}