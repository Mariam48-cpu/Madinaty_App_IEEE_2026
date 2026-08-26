import 'package:flutter/material.dart';
import 'skeleton_primitives.dart';

class ProfileSkeleton extends StatelessWidget { const ProfileSkeleton({super.key}); @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),physics:const NeverScrollableScrollPhysics(),children:const[SizedBox(height:20),Center(child:AppSkeleton(width:92,height:92,radius:46)),SizedBox(height:14),Center(child:SkeletonText(widthFactor:.38,height:18)),SizedBox(height:8),Center(child:SkeletonText(widthFactor:.48,height:11)),SizedBox(height:28),AppSkeleton(height:58,radius:18),SizedBox(height:12),AppSkeleton(height:58,radius:18),SizedBox(height:12),AppSkeleton(height:58,radius:18),SizedBox(height:12),AppSkeleton(height:58,radius:18)]); }
