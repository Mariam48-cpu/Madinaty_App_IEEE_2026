import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/use_cases/get_cafe_menu_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/create_pre_order_use_case.dart';
import 'pre_order_state.dart';

@injectable
class PreOrderCubit extends Cubit<PreOrderState> {
  final GetCafeMenuUseCase getCafeMenuUseCase;
  final CreatePreOrderUseCase createPreOrderUseCase;

  PreOrderCubit({
    required this.getCafeMenuUseCase,
    required this.createPreOrderUseCase,
  }) : super(const PreOrderInitial());

  Future<void> loadMenu({
    required String cafeId,
    BookingEntity? booking,
    String? cafeName,
    List<MenuCategoryEntity>? preloadedCategories,
  }) async {
    emit(const PreOrderLoading());

    try {
      List<MenuCategoryEntity> categories = preloadedCategories ?? [];
      if (categories.isEmpty) {
        categories = await getCafeMenuUseCase(cafeId);
      }

      final List<ProductEntity> allProducts = categories
          .expand((category) => category.products)
          .toList();

      emit(PreOrderLoaded(
        categories: categories,
        allProducts: allProducts,
        booking: booking,
        cafeName: cafeName ?? 'Roastery Lab',
      ));
    } catch (e) {
      emit(PreOrderError(e.toString()));
    }
  }

  void selectCategory(String categoryId) {
    if (state is PreOrderLoaded) {
      emit((state as PreOrderLoaded).copyWith(selectedCategoryId: categoryId));
    }
  }

  void setSearchQuery(String query) {
    if (state is PreOrderLoaded) {
      emit((state as PreOrderLoaded).copyWith(searchQuery: query));
    }
  }
}
