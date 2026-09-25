import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_card.dart';
import '../models/game_level.dart';
import '../services/game_storage.dart';
import '../theme/neo_brutalism_theme.dart';
import '../widgets/neo_badge.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_card.dart';
import '../widgets/victory_dialog.dart';

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
    });
    _startTimer();
  }

  void _onCardTapped(int index) {
    if (_isProcessing) return;
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

          _checkVictory();
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
        });
      }
    }
  }

  int _calculateStars() {
    if (_movesCount <= _currentLevel.targetMoves) {
      return 3;
    } else if (_movesCount <= (_currentLevel.targetMoves * 1.5).round()) {
      return 2;
    } else {
      return 1;
    }
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
        child: Column(
          children: [
            // Custom Neo-Brutalist App Bar
            _buildAppBar(),

            // Top Stat Bar (Percobaan, Pasangan, Waktu)
            _buildStatsBar(),

            // Game Board Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _currentLevel.cols / _currentLevel.rows,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cards.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _currentLevel.cols,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
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
                ),
              ),
            ),

            // Bottom Control Action
            _buildBottomControls(),
          ],
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

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: NeoBox.container(
                color: Colors.white,
                borderRadius: 12,
                borderWidth: 2.5,
                shadowOffset: const Offset(3, 3),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: NeoColors.dark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Target ≤ ${_currentLevel.targetMoves} moves untuk 3 ★',
                      style: NeoTypography.body(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          NeoButton(
            text: 'RESET',
            icon: Icons.replay,
            backgroundColor: NeoColors.primaryOrange,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onPressed: _startNewGame,
          ),
        ],
      ),
    );
  }
}
