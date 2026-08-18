import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/use_cases/get_cafe_experience_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/use_cases/get_cafe_menu_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'cafe_state.dart';

@injectable
class CafeCubit extends Cubit<CafeState> {
  final GetCafeExperienceUseCase getCafeExperienceUseCase;
  final GetCafeMenuUseCase getCafeMenuUseCase;

  CafeCubit({
    required this.getCafeExperienceUseCase,
    required this.getCafeMenuUseCase,
  }) : super(const CafeInitial());

  Future<void> getCafeExperience(CafeEntity cafe) async {
    emit(const CafeLoading());

    try {
      final experience = await getCafeExperienceUseCase(cafe);

      emit(CafeLoaded(experience: experience));
    } catch (e) {
      emit(CafeError(message: e.toString()));
    }
  }

  Future<void> getCafeMenu(String cafeId) async {
    try {
      final menu = await getCafeMenuUseCase(cafeId);

      emit(CafeMenuLoaded(menu: menu));
    } catch (e) {
      emit(CafeError(message: e.toString()));
    }
  }
}
