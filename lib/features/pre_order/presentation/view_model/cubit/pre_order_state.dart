import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

abstract class PreOrderState {
  const PreOrderState();
}

class PreOrderInitial extends PreOrderState {
  const PreOrderInitial();
}

class PreOrderLoading extends PreOrderState {
  const PreOrderLoading();
}

class PreOrderLoaded extends PreOrderState {
  final List<MenuCategoryEntity> categories;
  final List<ProductEntity> allProducts;
  final String selectedCategoryId;
  final String searchQuery;
  final BookingEntity? booking;
  final String? cafeName;

  const PreOrderLoaded({
    required this.categories,
    required this.allProducts,
    this.selectedCategoryId = 'all',
    this.searchQuery = '',
    this.booking,
    this.cafeName,
  });

  List<ProductEntity> get filteredProducts {
    List<ProductEntity> list;
    if (selectedCategoryId == 'all') {
      list = allProducts;
    } else {
      list = allProducts.where((p) => p.categoryId == selectedCategoryId).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(query)).toList();
    }

    return list;
  }

  PreOrderLoaded copyWith({
    List<MenuCategoryEntity>? categories,
    List<ProductEntity>? allProducts,
    String? selectedCategoryId,
    String? searchQuery,
    BookingEntity? booking,
    String? cafeName,
  }) {
    return PreOrderLoaded(
      categories: categories ?? this.categories,
      allProducts: allProducts ?? this.allProducts,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      booking: booking ?? this.booking,
      cafeName: cafeName ?? this.cafeName,
    );
  }
}

class PreOrderError extends PreOrderState {
  final String message;

  const PreOrderError(this.message);
}
