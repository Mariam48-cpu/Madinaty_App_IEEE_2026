import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';
import '../../theme/app_colors.dart';

class PaymentWebViewSkeleton extends StatelessWidget { const PaymentWebViewSkeleton({super.key}); @override Widget build(BuildContext context)=>Container(color:AppColors.background,alignment:Alignment.center,child:const Column(mainAxisSize:MainAxisSize.min,children:[AppSkeleton(width:110,height:110,radius:28),SizedBox(height:18),SkeletonText(widthFactor:.55,height:14),SizedBox(height:9),SkeletonText(widthFactor:.4,height:10)])); }
