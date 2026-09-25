import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../theme/neo_brutalism_theme.dart';
import 'neo_button.dart';

class VictoryDialog extends StatelessWidget {
  final GameLevel level;
  final int moves;
  final int timeSeconds;
  final int stars;
  final VoidCallback onPlayAgain;
  final VoidCallback onNextLevel;
  final VoidCallback onMenu;

  const VictoryDialog({
    super.key,
    required this.level,
    required this.moves,
    required this.timeSeconds,
    required this.stars,
    required this.onPlayAgain,
    required this.onNextLevel,
    required this.onMenu,
  });

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNext = level.levelNumber < GameLevel.allLevels.length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: NeoBox.container(
          color: NeoColors.surface,
          borderRadius: 20,
          borderWidth: 4,
          shadowOffset: const Offset(8, 8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: NeoBox.container(
                color: NeoColors.primaryYellow,
                borderRadius: 8,
                borderWidth: 2.5,
                shadowOffset: const Offset(3, 3),
              ),
              child: Text(
                '★ LEVEL COMPLETED ★',
                style: NeoTypography.label(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Level Title
            Text(
              level.title,
              style: NeoTypography.heading(fontSize: 26),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final bool isLit = index < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isLit ? NeoColors.primaryYellow : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.dark, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: NeoColors.dark,
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.star,
                      size: 28,
                      color: isLit ? NeoColors.dark : Colors.grey.shade600,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Stat Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: NeoBox.container(
                      color: NeoColors.primaryCyan,
                      borderRadius: 12,
                      borderWidth: 2.5,
                      shadowOffset: const Offset(3, 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'MOVES',
                          style: NeoTypography.label(fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$moves',
                          style: NeoTypography.heading(fontSize: 22),
                        ),
                        Text(
                          'Target: ≤${level.targetMoves}',
                          style: NeoTypography.body(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: NeoBox.container(
                      color: NeoColors.primaryGreen,
                      borderRadius: 12,
                      borderWidth: 2.5,
                      shadowOffset: const Offset(3, 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'TIME',
                          style: NeoTypography.label(fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(timeSeconds),
                          style: NeoTypography.heading(fontSize: 22),
                        ),
                        Text(
                          'Cleared!',
                          style: NeoTypography.body(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Actions
            if (hasNext) ...[
              SizedBox(
                width: double.infinity,
                child: NeoButton(
                  text: 'NEXT LEVEL ➜',
                  backgroundColor: NeoColors.primaryPink,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNextLevel();
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: NeoButton(
                    text: 'RETRY',
                    icon: Icons.refresh,
                    backgroundColor: NeoColors.primaryYellow,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPlayAgain();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeoButton(
                    text: 'MENU',
                    icon: Icons.grid_view_rounded,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onMenu();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
