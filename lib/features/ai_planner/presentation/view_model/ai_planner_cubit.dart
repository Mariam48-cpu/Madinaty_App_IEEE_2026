import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/localization/app_locale.dart';
import '../../domain/entities/ai_plan_entity.dart';
import '../../domain/use_cases/create_ai_plan.dart';

abstract class AIPlannerState {
  const AIPlannerState();
}

class AIPlannerInitial extends AIPlannerState {
  const AIPlannerInitial();
}

class AIPlannerLoading extends AIPlannerState {
  const AIPlannerLoading();
}

class AIPlannerSuccess extends AIPlannerState {
  final AIPlanEntity plan;
  const AIPlannerSuccess(this.plan);
}

class AIPlannerError extends AIPlannerState {
  final String message;
  const AIPlannerError(this.message);
}

@injectable
class AIPlannerCubit extends Cubit<AIPlannerState> {
  final CreateAIPlan createAIPlan;

  AIPlannerCubit(this.createAIPlan) : super(const AIPlannerInitial());

  Future<void> createPlan({
    required String message,
    required double budget,
    required int durationHours,
    List<String> interests = const [],
    String? mood,
    String? occasion,
  }) async {
    if (message.trim().isEmpty) {
      emit(const AIPlannerError(AppLocale.aiInputEmptyPrompt));
      return;
    }

    emit(const AIPlannerLoading());

    try {
      final plan = await createAIPlan(
        AIPlanRequestEntity(
          message: message.trim(),
          budget: budget,
          durationHours: durationHours,
          interests: interests,
          mood: mood,
          occasion: occasion,
        ),
      );
      emit(AIPlannerSuccess(plan));
    } catch (e) {
      emit(AIPlannerError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(const AIPlannerInitial());
}