import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/pre_order_skeleton.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/screens/book_table_screen.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view_model/cubit/booking_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/product_datails_screen.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/entities/cart_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_state.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/screens/checkout_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:latlong2/latlong.dart';
import '../../view_model/cubit/pre_order_cubit.dart';
import '../../view_model/cubit/pre_order_state.dart';
import '../widgets/pre_order_bottom_bar.dart';
import '../widgets/pre_order_category_chips.dart';
import '../widgets/pre_order_product_grid_card.dart';
import '../widgets/pre_order_table_banner.dart';

class PreOrderScreen extends StatelessWidget {
  final BookingEntity? booking;
  final String cafeId;
  final String? cafeName;
  final CafeEntity? cafe;

  const PreOrderScreen({
    super.key,
    this.booking,
    this.cafeId = 'cafe_default',
    this.cafeName,
    this.cafe,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCafeId = booking?.cafeId ?? cafe?.id ?? cafeId;
    final effectiveCafeName = cafeName ?? cafe?.name ?? 'روستري لب';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<PreOrderCubit>()
            ..loadMenu(
              cafeId: effectiveCafeId,
              booking: booking,
              cafeName: effectiveCafeName,
            ),
        ),
        BlocProvider(
          create: (_) =>
              getIt<CartCubit>()..initCartWatcher(cafeName: effectiveCafeName),
        ),
      ],
      child: _PreOrderView(
        booking: booking,
        cafeName: effectiveCafeName,
        cafeId: effectiveCafeId,
        cafe: cafe,
      ),
    );
  }
}

class _PreOrderView extends StatefulWidget {
  final BookingEntity? booking;
  final String cafeName;
  final String cafeId;
  final CafeEntity? cafe;

  const _PreOrderView({
    this.booking,
    required this.cafeName,
    required this.cafeId,
    this.cafe,
  });

  @override
  State<_PreOrderView> createState() => _PreOrderViewState();
}

class _PreOrderViewState extends State<_PreOrderView> {
  bool _isSearching = false;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getProductQuantity(CartState cartState, ProductEntity product) {
    if (cartState is CartLoaded) {
      return cartState.items
          .where(
            (item) =>
                item.id == product.id || item.id.startsWith('${product.id}_'),
          )
          .fold(0, (sum, item) => sum + item.quantity);
    }
    return 0;
  }

  CartItemEntity? _findItemForRemoval(
    List<CartItemEntity> items,
    String productId,
  ) {
    for (final item in items) {
      if (item.id == productId) {
        return item;
      }
    }
    for (final item in items.reversed) {
      if (item.id.startsWith('${productId}_')) {
        return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final preOrderCubit = context.read<PreOrderCubit>();
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceVariant,
            child: IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    preOrderCubit.setSearchQuery('');
                  }
                });
              },
            ),
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (query) => preOrderCubit.setSearchQuery(query),
                decoration: InputDecoration(
                  hintText: AppLocale.searchMenuPlaceholder.getString(context),
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              )
            : Column(
                children: [
                  Text(
                    AppLocale.preOrderMenuTitle.getString(context),
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.cafeName,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceVariant,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<PreOrderCubit, PreOrderState>(
        builder: (context, preOrderState) {
          if (preOrderState is PreOrderInitial ||
              preOrderState is PreOrderLoading) {
            return const PreOrderSkeleton();
          }

          if (preOrderState is PreOrderError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      preOrderState.message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        preOrderCubit.loadMenu(
                          cafeId: widget.booking?.cafeId ?? 'cafe_default',
                          booking: widget.booking,
                          cafeName: widget.cafeName,
                        );
                      },
                      child: Text(AppLocale.retry.getString(context)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (preOrderState is PreOrderLoaded) {
            final products = preOrderState.filteredProducts;

            return BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final double cartSubtotal = cartState is CartLoaded
                    ? cartState.subtotal
                    : 0.0;
                final int cartItemCount = cartState is CartLoaded
                    ? cartState.totalItemsCount
                    : 0;

                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              child: PreOrderTableBanner(
                                booking: widget.booking,
                                cafeName: widget.cafeName,
                                onEdit: () {
                                  final cafeEntity =
                                      widget.cafe ??
                                      CafeEntity(
                                        id: widget.cafeId,
                                        name: widget.cafeName,
                                        location: const LatLng(
                                          30.0131,
                                          31.4913,
                                        ),
                                        address: '',
                                        description: '',
                                        rating: 4.5,
                                        photos: const [],
                                      );

                                  final bookingCubit = getIt<BookingCubit>()
                                    ..setCafeId(cafeEntity.id);
                                  if (widget.booking != null) {
                                    if (widget.booking!.date != null) {
                                      bookingCubit.selectDate(
                                        widget.booking!.date!,
                                      );
                                    }
                                    if (widget.booking!.time != null) {
                                      bookingCubit.selectTime(
                                        widget.booking!.time!,
                                      );
                                    }
                                    bookingCubit.guests =
                                        widget.booking!.guests;
                                    if (widget.booking!.occasion != null) {
                                      bookingCubit.selectOccasion(
                                        widget.booking!.occasion!,
                                      );
                                    }
                                    if (widget.booking!.seatingPreference !=
                                        null) {
                                      bookingCubit.selectSeatingPreference(
                                        widget.booking!.seatingPreference!,
                                      );
                                    }
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: bookingCubit,
                                        child: BookTableScreen(
                                          cafe: cafeEntity,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Horizontal Category Chips Filter
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: PreOrderCategoryChips(
                                categories: preOrderState.categories,
                                selectedCategoryId:
                                    preOrderState.selectedCategoryId,
                                onCategorySelected: (catId) {
                                  preOrderCubit.selectCategory(catId);
                                },
                              ),
                            ),
                          ),

                          // 2-Column Product Grid
                          if (products.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: Text(
                                  AppLocale.emptyCartSubtitle.getString(
                                    context,
                                  ),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final product = products[index];
                                  final quantity = _getProductQuantity(
                                    cartState,
                                    product,
                                  );

                                  return PreOrderProductGridCard(
                                    product: product,
                                    quantity: quantity,
                                    onAdd: () {
                                      cartCubit.addToCart(
                                        CartItemEntity(
                                          id: product.id,
                                          title: product.name,
                                          price: product.price,
                                          quantity: 1,
                                          imageUrl: product.image.isNotEmpty
                                              ? product.image
                                              : null,
                                        ),
                                      );
                                    },
                                    onRemove: () {
                                      if (cartState is CartLoaded) {
                                        final itemToRemove =
                                            _findItemForRemoval(
                                              cartState.items,
                                              product.id,
                                            );
                                        if (itemToRemove != null) {
                                          cartCubit.decrementQuantity(
                                            itemToRemove,
                                          );
                                        }
                                      }
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }, childCount: products.length),
                              ),
                            ),
                        ],
                      ),
                    ),

                    PreOrderBottomBar(
                      totalPrice: cartSubtotal,
                      itemCount: cartItemCount,
                      onSkip: () {
                        if (widget.booking != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CheckoutScreen(booking: widget.booking!),
                            ),
                          );
                        } else {
                          Navigator.pushNamed(context, AppRoutes.checkout);
                        }
                      },
                      onProceed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.cart,
                          arguments: widget.cafeName,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
