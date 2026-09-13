import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/custom_button.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/domain/entities/review_entity.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view_model/cubit/reviews_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view_model/cubit/reviews_state.dart';
import 'package:toastification/toastification.dart';
import '../widgets/interactive_star_rating_selector.dart';

class WriteReviewScreen extends StatelessWidget {
  final String cafeId;
  final String cafeName;
  final ReviewEntity? existingReview;

  const WriteReviewScreen({
    super.key,
    required this.cafeId,
    this.cafeName = '',
    this.existingReview,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewsCubit>(),
      child: _WriteReviewScreenBody(
        cafeId: cafeId,
        cafeName: cafeName,
        existingReview: existingReview,
      ),
    );
  }
}

class _WriteReviewScreenBody extends StatefulWidget {
  final String cafeId;
  final String cafeName;
  final ReviewEntity? existingReview;

  const _WriteReviewScreenBody({
    required this.cafeId,
    required this.cafeName,
    this.existingReview,
  });

  @override
  State<_WriteReviewScreenBody> createState() => _WriteReviewScreenBodyState();
}

class _WriteReviewScreenBodyState extends State<_WriteReviewScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textController;
  double _rating = 5.0;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.existingReview?.text ?? '',
    );
    _rating = widget.existingReview?.rating ?? 5.0;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    setState(() => _validationError = null);

    if (_rating <= 0) {
      setState(() {
        _validationError = AppLocale.ratingRequired.getString(context);
      });
      return;
    }

    final comment = _textController.text.trim();
    if (comment.isEmpty) {
      setState(() {
        _validationError = AppLocale.commentRequired.getString(context);
      });
      return;
    }

    final cubit = context.read<ReviewsCubit>();
    if (!cubit.isAuthenticated) {
      AppToast.showToast(
        context: context,
        title: AppLocale.toastError.getString(context),
        description: AppLocale.loginRequiredToReview.getString(context),
        type: ToastificationType.error,
      );
      return;
    }

    final success = await cubit.submitReview(
      cafeId: widget.cafeId,
      rating: _rating,
      text: comment,
      existingReviewId: widget.existingReview?.id,
    );

    if (success && mounted) {
      AppToast.showToast(
        context: context,
        title: AppLocale.toastSuccess.getString(context),
        description: AppLocale.reviewSubmittedSuccess.getString(context),
        type: ToastificationType.success,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReview != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom App Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 42),
                  Text(
                    isEditing
                        ? AppLocale.editReview.getString(context)
                        : AppLocale.writeYourReview.getString(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2521),
                    ),
                  ),
                  // Back Button (Circle on Right for RTL)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF2D2521),
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // --- Form Content ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.cafeName.isNotEmpty) ...[
                        Text(
                          widget.cafeName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A5A36),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // --- Star Rating Selection Card ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF1E9E2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocale.yourRating.getString(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2521),
                              ),
                            ),
                            const SizedBox(height: 16),
                            InteractiveStarRatingSelector(
                              currentRating: _rating,
                              onRatingChanged: (val) {
                                setState(() {
                                  _rating = val;
                                  _validationError = null;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8A5A36),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- Review Text Input Card ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF1E9E2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _textController,
                              maxLines: 5,
                              minLines: 4,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2D2521),
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                hintText: AppLocale.writeReviewHint.getString(context),
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFA89E96),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) {
                                if (_validationError != null) {
                                  setState(() => _validationError = null);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // --- Error Message Display ---
                      if (_validationError != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _validationError!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // --- Submit Button ---
                      BlocBuilder<ReviewsCubit, ReviewsState>(
                        builder: (context, state) {
                          final isSubmitting =
                              state is ReviewsLoaded && state.isSubmitting;

                          return CustomButton(
                            text: AppLocale.submitReview.getString(context),
                            isLoading: isSubmitting,
                            onPressed: isSubmitting ? null : _submitReview,
                            backgroundColor: const Color(0xFF1E1E1E),
                            textColor: Colors.white,
                            width: double.infinity,
                            height: 52,
                            borderRadius: 16,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
