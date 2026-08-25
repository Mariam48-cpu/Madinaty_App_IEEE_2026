import 'package:flutter/material.dart';

class PromptField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const PromptField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<PromptField> createState() => _PromptFieldState();
}

class _PromptFieldState extends State<PromptField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;

    return Container(
      height: 185,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasText
              ? const Color(0xFF8B5E3C)
              : const Color(0xFFE7DDD4),
          width: hasText ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: TextField(
              controller: widget.controller,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: null,
              maxLines: null,
              expands: true,
              autofocus: false,
              style: const TextStyle(
                color: Color(0xFF2E241F),
                fontSize: 14,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText:
                    'مثلاً:\n'
                    'عايزة أخرج مع صحابي النهارده، نبدأ بكافيه هادي '
                    'وبعدها ناكل حاجة حلوة، والميزانية حوالي 500 جنيه.',
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                  color: const Color(0xFF82756D).withOpacity(.72),
                  fontSize: 14,
                  height: 1.6,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(
                  17,
                  16,
                  17,
                  58,
                ),
              ),
            ),
          ),

          Positioned(
            left: 12,
            bottom: 12,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: hasText
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFFE8DED5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'إرسال',
                onPressed: hasText
                    ? widget.onSubmitted
                    : null,
                icon: Icon(
                  Icons.arrow_upward_rounded,
                  size: 23,
                  color: hasText
                      ? Colors.white
                      : const Color(0xFF81766F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}