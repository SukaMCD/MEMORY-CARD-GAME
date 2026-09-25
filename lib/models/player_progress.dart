class PlayerProgress {
  final int levelNumber;
  bool isUnlocked;
  int? bestMoves;
  int? bestTimeSeconds;
  int stars;

  PlayerProgress({
    required this.levelNumber,
    required this.isUnlocked,
    this.bestMoves,
    this.bestTimeSeconds,
    this.stars = 0,
  });

  void updateScore({required int moves, required int timeSeconds, required int newStars}) {
    if (bestMoves == null || moves < bestMoves!) {
      bestMoves = moves;
    }
    if (bestTimeSeconds == null || timeSeconds < bestTimeSeconds!) {
      bestTimeSeconds = timeSeconds;
    }
    if (newStars > stars) {
      stars = newStars;
    }
  }
}
