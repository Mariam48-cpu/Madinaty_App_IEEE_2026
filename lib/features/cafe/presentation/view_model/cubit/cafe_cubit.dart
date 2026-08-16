import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import 'cafe_state.dart';

@injectable
class CafeCubit extends Cubit<CafeState> {
  final CafeeRepositoryInterface repository;

  CafeCubit({required this.repository}) : super(CafeInitial());

  Future<void> getCafeExperience(CafeEntity cafe) async {
    emit(CafeLoading());

    try {
      final experience = await repository.getCafeExperience(cafe);

      emit(CafeLoaded(experience: experience));
    } catch (e) {
      emit(CafeError(message: e.toString()));
    }
  }

  Future<void> getCafeMenu(String cafeId) async {
    try {
      final menu = await repository.getCafeMenu(cafeId);

      emit(CafeMenuLoaded(menu: menu));
    } catch (e) {
      emit(CafeError(message: e.toString()));
    }
  }
}
