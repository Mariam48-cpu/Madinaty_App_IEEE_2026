import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SkeletonText extends StatelessWidget {
  const SkeletonText({super.key, this.widthFactor = .7, this.height = 12, this.radius = 6});
  final double widthFactor;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: widthFactor.clamp(.1, 1),
        alignment: AlignmentDirectional.centerStart,
        child: AppSkeleton(height: height, radius: radius),
      );
}

class SkeletonSectionTitle extends StatelessWidget {
  const SkeletonSectionTitle({super.key, this.widthFactor = .38});
  final double widthFactor;
  @override
  Widget build(BuildContext context) => SkeletonText(widthFactor: widthFactor, height: 18, radius: 7);
}

class SkeletonChip extends StatelessWidget {
  const SkeletonChip({super.key, this.width = 76, this.height = 38});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) => AppSkeleton(width: width, height: height, radius: height / 2);
}

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({super.key, this.width, this.height, this.radius = 16, this.margin = EdgeInsets.zero});
  final double? width;
  final double? height;
  final double radius;
  final EdgeInsets margin;
  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1450))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(widget.radius)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final value = (_controller.value * 2.6) - 1.0;
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [AppColors.surfaceVariant, Color(0xFFF4EDE5), AppColors.surfaceVariant],
              stops: [(value - .35).clamp(0.0, 1.0), value.clamp(0.0, 1.0), (value + .35).clamp(0.0, 1.0)],
            ).createShader(rect),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}
