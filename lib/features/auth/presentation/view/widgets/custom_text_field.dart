import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF5F1EC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : (widget.suffixIcon != null
                      ? Icon(widget.suffixIcon, color: Colors.grey)
                      : null),
          ),
        ),
      ],
    );
  }
}
