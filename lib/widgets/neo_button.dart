import 'package:flutter/material.dart';
import '../theme/neo_brutalism_theme.dart';

class NeoButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderWidth;
  final double borderRadius;
  final double shadowDepth;
  final EdgeInsets padding;
  final double? width;
  final double? height;

  const NeoButton({
    super.key,
    this.child,
    this.text,
    this.icon,
    required this.onPressed,
    this.backgroundColor = NeoColors.primaryYellow,
    this.textColor = NeoColors.dark,
    this.borderWidth = 3.0,
    this.borderRadius = 12.0,
    this.shadowDepth = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.width,
    this.height,
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final currentShadow = _isPressed || !isEnabled ? 0.0 : widget.shadowDepth;
    final currentTranslation = _isPressed || !isEnabled ? widget.shadowDepth : 0.0;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: Transform.translate(
        offset: Offset(currentTranslation, currentTranslation),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: isEnabled ? widget.backgroundColor : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: NeoColors.dark,
              width: widget.borderWidth,
            ),
            boxShadow: currentShadow > 0
                ? [
                    BoxShadow(
                      color: NeoColors.dark,
                      offset: Offset(currentShadow, currentShadow),
                      blurRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: widget.child ??
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.textColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  if (widget.text != null)
                    Text(
                      widget.text!,
                      style: NeoTypography.subHeading(
                        fontSize: 16,
                        color: widget.textColor,
                      ),
                    ),
                ],
              ),
        ),
      ),
    );
  }
}
