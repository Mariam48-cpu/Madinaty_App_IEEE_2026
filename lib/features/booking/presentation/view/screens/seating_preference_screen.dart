import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/cafe_header_card.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/widgets/legend_item.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

import '../../view_model/cubit/booking_cubit.dart';
import '../../view_model/cubit/booking_state.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/seating_filter_chip.dart';
import '../widgets/seating_map.dart';

class SeatingPreferenceScreen extends StatefulWidget {
  final CafeEntity cafe;

  const SeatingPreferenceScreen({super.key, required this.cafe});

  @override
  State<SeatingPreferenceScreen> createState() =>
      _SeatingPreferenceScreenState();
}

class _SeatingPreferenceScreenState extends State<SeatingPreferenceScreen> {
  String selectedFilter = 'الكل';
  String? selectedTable = 'T3';

  final filters = ['الكل', 'إطلالة النيل', 'ركن هادئ', 'بجوار النافذة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'اختيار الجلسة',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 18,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تأكيد الحجز بنجاح 🎉')),
              );

              Navigator.popUntil(context, (route) => route.isFirst);
            }

            if (state is BookingFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<BookingCubit>();

            final isLoading = state is BookingLoading;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CafeHeaderCard(
                          cafeName: widget.cafe.name,
                          cafeAddress: widget.cafe.address,
                          cafeImageUrl: widget.cafe.photos.isNotEmpty
                              ? widget.cafe.photos.first
                              : null,
                        ),

                        SizedBox(height: 12),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الوقت: ${cubit.time ?? '--'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                'عدد الأشخاص: ${cubit.guests}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LegendItem(title: 'متاح', color: Color(0xFFF3EDE7)),
                            SizedBox(width: 18),
                            LegendItem(title: 'محدد', color: Color(0xFF6E4027)),
                            SizedBox(width: 18),
                            LegendItem(
                              title: 'محجوز',
                              color: Color(0xFFE8E4E1),
                            ),
                          ],
                        ),

                        SizedBox(height: 18),

                        SizedBox(
                          height: 38,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filters.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 7),
                            itemBuilder: (context, index) {
                              final filter = filters[index];

                              return SeatingFilterChip(
                                title: filter,
                                selected: selectedFilter == filter,
                                onTap: () {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 18),

                        SeatingMap(
                          filterCategory: selectedFilter,
                          selectedTable: selectedTable,
                          onTableSelected: (table) {
                            setState(() {
                              selectedTable = table;
                            });
                          },
                        ),

                        SizedBox(height: 18),

                        Text(
                          'اختاري المكان اللي يناسبك',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      BookingSummaryCard(
                        table: selectedTable ?? 'T3',
                        time: cubit.time,
                        guests: cubit.guests,
                      ),

                      SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (selectedTable == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('اختاري طاولة أولاً'),
                                      ),
                                    );
                                    return;
                                  }

                                  cubit.selectSeatingPreference(selectedTable!);

                                  cubit.createBooking();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textDark,
                            disabledBackgroundColor: Colors.grey.shade400,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'تأكيد الحجز',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
