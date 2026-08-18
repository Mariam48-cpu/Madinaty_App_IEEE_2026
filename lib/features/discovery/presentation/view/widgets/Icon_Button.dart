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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE8DED8)),
          ),
          child: Icon(widget.icon, size: 19, color: Color(0xFF4A403B)),
        ),
      ),
    );
  }
}
