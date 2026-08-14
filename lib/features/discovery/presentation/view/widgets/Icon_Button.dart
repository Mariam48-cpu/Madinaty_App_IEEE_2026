import 'package:flutter/material.dart';

class IconButtonWidget extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconButtonWidget({required this.icon, required this.onTap}) : super();

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding:  EdgeInsets.all(8),
        decoration:  BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Icon(widget.icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
