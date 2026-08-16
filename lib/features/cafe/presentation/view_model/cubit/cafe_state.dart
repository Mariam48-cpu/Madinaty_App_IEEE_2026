import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/cafe_experience_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';

abstract class CafeState {
  const CafeState();
}

class CafeInitial extends CafeState {
  const CafeInitial();
}

class CafeLoading extends CafeState {
  const CafeLoading();
}

class CafeLoaded extends CafeState {
  final CafeExperienceEntity experience;

  const CafeLoaded({required this.experience});
}

class CafeMenuLoaded extends CafeState {
  final List<MenuCategoryEntity> menu;

  const CafeMenuLoaded({required this.menu});
}

class CafeError extends CafeState {
  final String message;

  const CafeError({required this.message});
}
