import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/entities/ai_plan_entity.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/domain/repositories/ai_planner_repository.dart';

import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/ai_planner_top_bar.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/ai_hero.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/prompt_field.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/quick_picks.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/mood_chips.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/planner_controls_card.dart';
import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/plan_button.dart';

import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/processing/processing_screen.dart';

import 'package:madinaty_app_ieee_2026/features/ai_planner/presentation/view/widgets/result/result_screen.dart';

class AIPlannerPage extends StatefulWidget {
  const AIPlannerPage({super.key});

  @override
  State<AIPlannerPage> createState() => _AIPlannerPageState();
}

class _AIPlannerPageState extends State<AIPlannerPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController =
      TextEditingController();

  final AIPlannerRepository _repository =
      GetIt.I<AIPlannerRepository>();

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

  final List<String> _processingMessages = [
    'بفهم طلبك وذوقك...',
    'بدور على أحسن أماكن قريبة...',
    'براجع حالة الجو النهارده...',
    'بجهزلك اليوم المثالي...',
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
      _showMessage('اكتبلي عايز تعمل إيه النهارده ✨');
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
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
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

        if (_processingStep < _processingMessages.length - 1) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _AIColors.background,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _buildCurrentView(),
          ),
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
          processingMessages: _processingMessages,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
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

            const Text(
              'إيه اللي نفسك تعمله النهارده؟',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: _AIColors.text,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'احكيلي براحتك، وأنا هفهمك وأرتبلك اليوم على ذوقك.',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: _AIColors.muted,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 16),

            PromptField(
              controller: _messageController,
              onSubmitted: _createPlan,
            ),

            const SizedBox(height: 22),

            _buildSectionTitle('اختيارات سريعة'),

            const SizedBox(height: 12),

            QuickPicks(
              interests: _interests,
              onToggle: _toggleInterest,
              controller: _messageController,
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('إيه المود بتاعك؟'),

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

            const Center(
              child: Text(
                'Powered by Madinaty AI ✨',
                style: TextStyle(
                  color: _AIColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
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

              const Text(
                'مش قادر أجهزلك الخطة 😕',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _AIColors.text,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _errorMessage ??
                    'حصلت مشكلة بسيطة، جرّب تاني.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _AIColors.muted,
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
                    backgroundColor: _AIColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'جرب تاني',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: _AIColors.text,
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

class _AIColors {
  static const Color background = Color(0xFFF8F3EC);
  static const Color primary = Color(0xFF8B5E3C);
  static const Color text = Color(0xFF2E241F);
  static const Color muted = Color(0xFF82756D);
} 