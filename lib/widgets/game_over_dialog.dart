import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../theme/neo_brutalism_theme.dart';
import 'neo_button.dart';

class GameOverDialog extends StatelessWidget {
  final GameLevel level;
  final int moves;
  final int matchesFound;
  final int timeSeconds;
  final VoidCallback onPlayAgain;
  final VoidCallback onMenu;

  const GameOverDialog({
    super.key,
    required this.level,
    required this.moves,
    required this.matchesFound,
    required this.timeSeconds,
    required this.onPlayAgain,
    required this.onMenu,
  });

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
                color: NeoColors.primaryPink,
                borderRadius: 8,
                borderWidth: 2.5,
                shadowOffset: const Offset(3, 3),
              ),
              child: Text(
                '✖ GAME OVER ✖',
                style: NeoTypography.label(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Icon / Emoji Circle
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: NeoColors.primaryPink.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: NeoColors.dark, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: NeoColors.dark,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.sentiment_very_dissatisfied_rounded,
                  size: 44,
                  color: NeoColors.primaryPink,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Title & Subtitle
            Text(
              'LANGKAH HABIS!',
              style: NeoTypography.heading(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Progress bar energimu sudah habis. Coba lagi dan temukan semua pasangan dengan langkah lebih hemat!',
              style: NeoTypography.body(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Stat Cards
            Row(
              children: [
                // MOVES
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: NeoBox.container(
                      color: NeoColors.primaryYellow,
                      borderRadius: 12,
                      borderWidth: 2.5,
                      shadowOffset: const Offset(3, 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'MOVES',
                          style: NeoTypography.label(fontSize: 10),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$moves',
                          style: NeoTypography.heading(fontSize: 20),
                        ),
                        Text(
                          'Maks: ${level.maxMoves}',
                          style: NeoTypography.body(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // MATCHED
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: NeoBox.container(
                      color: NeoColors.primaryCyan,
                      borderRadius: 12,
                      borderWidth: 2.5,
                      shadowOffset: const Offset(3, 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'MATCHED',
                          style: NeoTypography.label(fontSize: 10),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$matchesFound/${level.totalPairs}',
                          style: NeoTypography.heading(fontSize: 20),
                        ),
                        Text(
                          'Pasang',
                          style: NeoTypography.body(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // TIME
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
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
                          style: NeoTypography.label(fontSize: 10),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTime(timeSeconds),
                          style: NeoTypography.heading(fontSize: 20),
                        ),
                        Text(
                          'Berlalu',
                          style: NeoTypography.body(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: NeoButton(
                text: 'COBA LAGI',
                icon: Icons.refresh_rounded,
                backgroundColor: NeoColors.primaryYellow,
                onPressed: () {
                  Navigator.of(context).pop();
                  onPlayAgain();
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: NeoButton(
                text: 'PILIH LEVEL LAIN',
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
      ),
    );
  }
}
