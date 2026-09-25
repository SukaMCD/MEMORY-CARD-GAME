import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_card.dart';
import '../models/game_level.dart';
import '../services/game_storage.dart';
import '../theme/neo_brutalism_theme.dart';
import '../widgets/neo_badge.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_card.dart';
import '../widgets/victory_dialog.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  final GameLevel level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLevel _currentLevel;
  late List<GameCard> _cards;
  final List<int> _selectedIndices = [];
  bool _isProcessing = false;

  int _movesCount = 0;
  int _matchesFound = 0;
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.level;
    _startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _startNewGame() {
    setState(() {
      _cards = _currentLevel.generateCards();
      _selectedIndices.clear();
      _movesCount = 0;
      _matchesFound = 0;
      _isProcessing = false;
      _isGameOver = false;
    });
    _startTimer();
  }

  void _onCardTapped(int index) {
    if (_isProcessing || _isGameOver) return;
    if (_cards[index].isFaceUp || _cards[index].isMatched) return;
    if (_selectedIndices.contains(index)) return;

    setState(() {
      _cards[index].isFaceUp = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      _movesCount++;
      _isProcessing = true;

      final firstCard = _cards[_selectedIndices[0]];
      final secondCard = _cards[_selectedIndices[1]];

      if (firstCard.pairId == secondCard.pairId) {
        // MATCH!
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          setState(() {
            firstCard.isMatched = true;
            secondCard.isMatched = true;
            _matchesFound++;
            _selectedIndices.clear();
            _isProcessing = false;
          });

          if (_matchesFound == _currentLevel.totalPairs) {
            _checkVictory();
          } else if (_movesCount >= _currentLevel.maxMoves) {
            _checkGameOver();
          }
        });
      } else {
        // NOT MATCHED - Flip back after delay
        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          setState(() {
            firstCard.isFaceUp = false;
            secondCard.isFaceUp = false;
            _selectedIndices.clear();
            _isProcessing = false;
          });

          if (_movesCount >= _currentLevel.maxMoves) {
            _checkGameOver();
          }
        });
      }
    }
  }

  int _calculateStars() {
    if (_movesCount <= _currentLevel.targetMoves) {
      return 3;
    } else if (_movesCount <= (_currentLevel.targetMoves * 1.5).round()) {
      return 2;
    } else if (_movesCount < _currentLevel.maxMoves) {
      return 1;
    } else {
      return 0;
    }
  }

  void _checkGameOver() {
    _timer?.cancel();
    setState(() {
      _isGameOver = true;
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => GameOverDialog(
          level: _currentLevel,
          moves: _movesCount,
          matchesFound: _matchesFound,
          timeSeconds: _secondsElapsed,
          onPlayAgain: _startNewGame,
          onMenu: () => Navigator.of(context).pop(),
        ),
      );
    });
  }

  void _checkVictory() {
    if (_matchesFound == _currentLevel.totalPairs) {
      _timer?.cancel();
      final stars = _calculateStars();

      // Record in storage
      GameStorage().recordLevelCompletion(
        levelNumber: _currentLevel.levelNumber,
        moves: _movesCount,
        timeSeconds: _secondsElapsed,
        stars: stars,
      );

      // Show modal
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => VictoryDialog(
            level: _currentLevel,
            moves: _movesCount,
            timeSeconds: _secondsElapsed,
            stars: stars,
            onPlayAgain: _startNewGame,
            onNextLevel: _goToNextLevel,
            onMenu: () => Navigator.of(context).pop(),
          ),
        );
      });
    }
  }

  void _goToNextLevel() {
    final nextLevelIndex = _currentLevel.levelNumber; // 1-based, so index in list is current levelNumber
    if (nextLevelIndex < GameLevel.allLevels.length) {
      setState(() {
        _currentLevel = GameLevel.allLevels[nextLevelIndex];
      });
      _startNewGame();
    }
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                // Custom Neo-Brutalist App Bar
                _buildAppBar(),

                // Top Stat Bar (Percobaan, Pasangan, Waktu)
                _buildStatsBar(),

                // Game Board Grid (Responsif tinggi & lebar layar)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double spacing = _currentLevel.rows >= 4 ? 8.0 : 10.0;
                        final int cols = _currentLevel.cols;
                        final int rows = _currentLevel.rows;

                        final double maxCardWidth =
                            (constraints.maxWidth - (cols - 1) * spacing) / cols;
                        final double maxCardHeight =
                            (constraints.maxHeight - (rows - 1) * spacing) / rows;
                        final double cardSize = min(maxCardWidth, maxCardHeight);

                        final double boardWidth = cols * cardSize + (cols - 1) * spacing;
                        final double boardHeight = rows * cardSize + (rows - 1) * spacing;

                        return Center(
                          child: SizedBox(
                            width: boardWidth,
                            height: boardHeight,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _cards.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, index) {
                                return NeoCardWidget(
                                  key: ValueKey(_cards[index].id),
                                  card: _cards[index],
                                  isInteractive: !_isProcessing,
                                  onTap: () => _onCardTapped(index),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom Control Action
                _buildBottomControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: NeoBox.container(
        color: NeoColors.surface,
        borderRadius: 14,
        borderWidth: 3,
        shadowOffset: const Offset(4, 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: NeoBox.container(
                color: NeoColors.primaryPink,
                borderRadius: 8,
                borderWidth: 2,
                shadowOffset: const Offset(2, 2),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),

          // Title & Level Tag
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: _currentLevel.themeColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: NeoColors.dark, width: 2),
                ),
                child: Text(
                  _currentLevel.tag,
                  style: NeoTypography.label(fontSize: 10),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _currentLevel.title,
                style: NeoTypography.heading(fontSize: 18),
              ),
            ],
          ),

          // Restart button
          GestureDetector(
            onTap: _startNewGame,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: NeoBox.container(
                color: NeoColors.primaryYellow,
                borderRadius: 8,
                borderWidth: 2,
                shadowOffset: const Offset(2, 2),
              ),
              child: const Icon(Icons.refresh, color: NeoColors.dark, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        children: [
          // Percobaan / Moves
          Expanded(
            child: NeoBadge(
              label: 'MOVES',
              value: '$_movesCount',
              icon: Icons.touch_app_outlined,
              backgroundColor: NeoColors.primaryYellow,
            ),
          ),
          const SizedBox(width: 8),
          // Pasangan / Matched
          Expanded(
            child: NeoBadge(
              label: 'MATCHED',
              value: '$_matchesFound/${_currentLevel.totalPairs}',
              icon: Icons.check_circle_outline,
              backgroundColor: NeoColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 8),
          // Timer
          Expanded(
            child: NeoBadge(
              label: 'TIME',
              value: _formatTime(_secondsElapsed),
              icon: Icons.timer_outlined,
              backgroundColor: NeoColors.primaryCyan,
            ),
          ),
        ],
      ),
    );
  }

  /// Progress bar: penuh di awal (1.0), berkurang setiap move.
  /// Batas: 3★ = target, 2★ = 1.5×target, 1★ = 2.2×target, 0 = lebih dari itu.
  double _calculateBarProgress() {
    final int target = _currentLevel.targetMoves;
    final int twoStarLimit = (target * 1.5).round();
    final int hardLimit = _currentLevel.maxMoves;

    if (_movesCount == 0) return 1.0;
    if (_movesCount >= hardLimit) return 0.0;

    // Bar dibagi 3 segmen (masing-masing 1/3):
    // [1.0 → 0.667]  = zona 3 bintang (0..target moves)
    // [0.667 → 0.333] = zona 2 bintang (target..twoStarLimit moves)
    // [0.333 → 0.0]  = zona 1 bintang (twoStarLimit..hardLimit moves)
    if (_movesCount <= target) {
      final double t = target == 0 ? 1.0 : _movesCount / target;
      return 1.0 - (t * 0.333);
    } else if (_movesCount <= twoStarLimit) {
      final double range = (twoStarLimit - target).toDouble();
      final double t = range <= 0 ? 1.0 : (_movesCount - target) / range;
      return 0.667 - (t * 0.333);
    } else {
      final double range = (hardLimit - twoStarLimit).toDouble();
      final double t = range <= 0 ? 1.0 : (_movesCount - twoStarLimit) / range;
      return (0.334 - (t * 0.334)).clamp(0.0, 0.334);
    }
  }

  Widget _buildBottomControls() {
    // Posisi bintang di progress bar (dari kiri, sebagai widthFactor):
    // bintang 3 → threshold 3★ = 0.667 dari kiri
    // bintang 2 → threshold 2★ = 0.333 dari kiri
    // bintang 1 → threshold 1★ = 0.05 dari kiri (ujung kiri)
    const double star3Pos = 0.667;
    const double star2Pos = 0.333;
    const double star1Pos = 0.05;

    final double barProgress = _calculateBarProgress();

    // Bintang menyala jika bar progress masih melewati posisi bintang itu
    final bool star3Lit = barProgress >= star3Pos;
    final bool star2Lit = barProgress >= star2Pos;
    final bool star1Lit = barProgress >= star1Pos;

    Color barColor;
    if (star3Lit) {
      barColor = NeoColors.primaryYellow;
    } else if (star2Lit) {
      barColor = NeoColors.primaryOrange;
    } else if (star1Lit) {
      barColor = NeoColors.primaryPink;
    } else {
      barColor = Colors.grey.shade400;
    }

    // Definisi tiap bintang: [posisiBar, apakahMenyala]
    final List<(double, bool)> starDefs = [
      (star1Pos, star1Lit),
      (star2Pos, star2Lit),
      (star3Pos, star3Lit),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(
        children: [
          // Progress Bar dengan bintang di posisinya masing-masing
          Expanded(
            child: Container(
              height: 48,
              decoration: NeoBox.container(
                color: Colors.white,
                borderRadius: 12,
                borderWidth: 2.5,
                shadowOffset: const Offset(3, 3),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double totalWidth = constraints.maxWidth;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(9.5),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Track background
                        Container(color: const Color(0xFFF0F0F0)),

                        // Animated fill bar
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.centerLeft,
                          widthFactor: barProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: barColor,
                              border: const Border(
                                right: BorderSide(color: NeoColors.dark, width: 2.0),
                              ),
                            ),
                          ),
                        ),

                        // Garis pembatas vertikal di posisi setiap bintang
                        for (final (pos, _) in starDefs)
                          Positioned(
                            left: totalWidth * pos - 1,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              color: NeoColors.dark.withValues(alpha: 0.2),
                            ),
                          ),

                        // Bintang di posisi threshold masing-masing
                        for (final (pos, isLit) in starDefs)
                          Positioned(
                            left: (totalWidth * pos - 14).clamp(2, totalWidth - 30),
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOut,
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isLit ? NeoColors.primaryYellow : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: NeoColors.dark,
                                    width: 2.0,
                                  ),
                                  boxShadow: isLit
                                      ? const [
                                          BoxShadow(
                                            color: NeoColors.dark,
                                            offset: Offset(2, 2),
                                            blurRadius: 0,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  Icons.star,
                                  size: 14,
                                  color: isLit ? NeoColors.dark : Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          NeoButton(
            text: 'RESET',
            icon: Icons.replay,
            backgroundColor: NeoColors.primaryOrange,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            height: 48,
            onPressed: _startNewGame,
          ),
        ],
      ),
    );
  }
}
