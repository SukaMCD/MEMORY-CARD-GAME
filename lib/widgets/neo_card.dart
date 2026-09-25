import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_card.dart';
import '../theme/neo_brutalism_theme.dart';

class NeoCardWidget extends StatefulWidget {
  final GameCard card;
  final VoidCallback onTap;
  final bool isInteractive;

  const NeoCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    this.isInteractive = true,
  });

  @override
  State<NeoCardWidget> createState() => _NeoCardWidgetState();
}

class _NeoCardWidgetState extends State<NeoCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    if (widget.card.isFaceUp || widget.card.isMatched) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant NeoCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldBeFaceUp = widget.card.isFaceUp || widget.card.isMatched;
    if (shouldBeFaceUp && _controller.value < 0.5) {
      _controller.forward();
    } else if (!shouldBeFaceUp && _controller.value > 0.5) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final isFrontSide = _animation.value >= 0.5;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Perspective 3D
            ..rotateY(angle),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              if (widget.isInteractive &&
                  !widget.card.isFaceUp &&
                  !widget.card.isMatched) {
                widget.onTap();
              }
            },
            child: isFrontSide
                ? Transform(
                    // Flip back the front side text so it doesn't appear mirrored
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildFrontSide(),
                  )
                : _buildBackSide(),
          ),
        );
      },
    );
  }

  Widget _buildFrontSide() {
    return Container(
      decoration: BoxDecoration(
        color: widget.card.accentColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoColors.dark, width: 3.2),
        boxShadow: widget.card.isMatched
            ? [
                const BoxShadow(
                  color: NeoColors.dark,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                )
              ]
            : const [
                BoxShadow(
                  color: NeoColors.dark,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle pattern
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.15,
              child: Text(
                widget.card.emoji,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.card.emoji,
                style: const TextStyle(fontSize: 38),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: NeoColors.dark,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.card.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NeoTypography.label(
                    fontSize: 9,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (widget.card.isMatched)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: NeoColors.primaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: NeoColors.dark, width: 2),
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: NeoColors.dark,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6C5CE7), // Vivid purple brutalist back
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoColors.dark, width: 3.2),
        boxShadow: const [
          BoxShadow(
            color: NeoColors.dark,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Geometric hatched lines or checker accent
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF5B49DF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NeoColors.dark, width: 2),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: NeoColors.primaryYellow,
              shape: BoxShape.circle,
              border: Border.all(color: NeoColors.dark, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: NeoColors.dark,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              '?',
              style: NeoTypography.heading(fontSize: 22, color: NeoColors.dark),
            ),
          ),
        ],
      ),
    );
  }
}
