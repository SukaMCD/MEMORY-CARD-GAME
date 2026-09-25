import 'package:flutter/foundation.dart';
import '../models/player_progress.dart';

class GameStorage extends ChangeNotifier {
  static final GameStorage _instance = GameStorage._internal();
  factory GameStorage() => _instance;
  GameStorage._internal() {
    _initProgress();
  }

  final Map<int, PlayerProgress> _progressMap = {};

  void _initProgress() {
    for (int i = 1; i <= 5; i++) {
      _progressMap[i] = PlayerProgress(
        levelNumber: i,
        isUnlocked: i == 1, // Only level 1 is unlocked initially
      );
    }
  }

  PlayerProgress getProgress(int levelNumber) {
    return _progressMap[levelNumber] ??
        PlayerProgress(levelNumber: levelNumber, isUnlocked: levelNumber == 1);
  }

  bool isLevelUnlocked(int levelNumber) {
    return _progressMap[levelNumber]?.isUnlocked ?? false;
  }

  void recordLevelCompletion({
    required int levelNumber,
    required int moves,
    required int timeSeconds,
    required int stars,
  }) {
    final progress = _progressMap[levelNumber];
    if (progress != null) {
      progress.updateScore(
        moves: moves,
        timeSeconds: timeSeconds,
        newStars: stars,
      );
    }

    // Unlock next level if exists
    final nextLevel = levelNumber + 1;
    if (_progressMap.containsKey(nextLevel)) {
      _progressMap[nextLevel]!.isUnlocked = true;
    }

    notifyListeners();
  }

  void resetAll() {
    _initProgress();
    notifyListeners();
  }
}
