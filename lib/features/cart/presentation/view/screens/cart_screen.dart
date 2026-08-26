import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/cart_skeleton.dart';
import '../../view_model/cubit/cart_cubit.dart';
import '../../view_model/cubit/cart_state.dart';
import '../widgets/cart_empty_view.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_order_notes_widget.dart';
import '../widgets/cart_pickup_banner.dart';
import '../widgets/cart_summary_card.dart';

class CartScreen extends StatelessWidget {
  final String? cafeName;

  const CartScreen({super.key, this.cafeName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CartCubit>()..initCartWatcher(cafeName: cafeName),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatefulWidget {
  const _CartView();

  @override
  State<_CartView> createState() => _CartViewState();
}

class _CartViewState extends State<_CartView> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.cartTitle.getString(context),
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceVariant,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && !state.isEmpty) {
                return IconButton(
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: Color(0xFF8D6654),
                  ),
                  tooltip: AppLocale.clearCart.getString(context),
                  onPressed: () {
                    cubit.clearCart();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartLoaded &&
              _notesController.text.isEmpty &&
              state.orderNotes.isNotEmpty) {
            _notesController.text = state.orderNotes;
          }
        },
        builder: (context, state) {
          if (state is CartInitial || state is CartLoading) {
            return const CartSkeleton();
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => cubit.initCartWatcher(),
                    child: Text(AppLocale.retry.getString(context)),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.isEmpty) {
              return CartEmptyView(
                onExplore: () => Navigator.of(context).pop(),
              );
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CartPickupBanner(cafeName: state.cafeName),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return CartItemCard(
                            item: item,
                            onIncrement: () => cubit.incrementQuantity(item),
                            onDecrement: () => cubit.decrementQuantity(item),
                            onRemove: () => cubit.removeItem(item.id),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CartOrderNotesWidget(
                        controller: _notesController,
                        onChanged: (val) => cubit.setOrderNotes(val),
                      ),
                      const SizedBox(height: 20),
                      CartSummaryCard(
                        subtotal: state.subtotal,
                        serviceFee: state.serviceFee,
                        total: state.total,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.checkout);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkButton,
                          foregroundColor: AppColors.onDarkButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_outlined, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocale.proceedToCheckout.getString(context),
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.onDarkButton,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
