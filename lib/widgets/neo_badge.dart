import 'package:flutter/material.dart';
import '../theme/neo_brutalism_theme.dart';

class NeoBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color backgroundColor;
  final Color valueColor;

  const NeoBadge({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.backgroundColor = Colors.white,
    this.valueColor = NeoColors.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: NeoBox.container(
        color: backgroundColor,
        borderRadius: 10,
        borderWidth: 2.5,
        shadowOffset: const Offset(3, 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: NeoColors.dark),
                const SizedBox(width: 4),
              ],
              Text(
                label.toUpperCase(),
                style: NeoTypography.label(fontSize: 10, color: NeoColors.dark),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: NeoTypography.heading(fontSize: 18, color: valueColor),
          ),
        ],
      ),
    );
  }
}
