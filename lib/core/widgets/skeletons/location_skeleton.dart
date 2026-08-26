import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';

class LocationSkeleton extends StatelessWidget { const LocationSkeleton({super.key}); @override Widget build(BuildContext context)=>Column(children:const[SizedBox(height:30),AppSkeleton(width:90,height:90,radius:45),SizedBox(height:24),SkeletonText(widthFactor:.6,height:22),SizedBox(height:12),SkeletonText(widthFactor:.8,height:12),SizedBox(height:8),SkeletonText(widthFactor:.65,height:12),SizedBox(height:28),AppSkeleton(height:52,radius:17)]); }
