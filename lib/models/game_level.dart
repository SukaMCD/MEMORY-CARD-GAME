import 'package:flutter/material.dart';
import '../theme/neo_brutalism_theme.dart';
import 'game_card.dart';

class CardItemData {
  final String emoji;
  final String title;
  final Color color;

  const CardItemData({
    required this.emoji,
    required this.title,
    required this.color,
  });
}

class GameLevel {
  final int levelNumber;
  final String title;
  final String tag;
  final int rows;
  final int cols;
  final int totalPairs;
  final int targetMoves;
  final Color themeColor;
  final List<CardItemData> availableCards;

  const GameLevel({
    required this.levelNumber,
    required this.title,
    required this.tag,
    required this.rows,
    required this.cols,
    required this.totalPairs,
    required this.targetMoves,
    required this.themeColor,
    required this.availableCards,
  });

  int get totalCards => rows * cols;
  int get maxMoves => (targetMoves * 2.5).round().clamp(targetMoves + 2, 9999);

  /// Generates a shuffled list of pairs for this level
  List<GameCard> generateCards() {
    final List<GameCard> cards = [];
    final selectedPairs = availableCards.take(totalPairs).toList();

    for (int i = 0; i < selectedPairs.length; i++) {
      final item = selectedPairs[i];
      // Card A
      cards.add(GameCard(
        id: 'lvl_${levelNumber}_pair_${i}_a',
        pairId: i,
        emoji: item.emoji,
        title: item.title,
        accentColor: item.color,
      ));
      // Card B
      cards.add(GameCard(
        id: 'lvl_${levelNumber}_pair_${i}_b',
        pairId: i,
        emoji: item.emoji,
        title: item.title,
        accentColor: item.color,
      ));
    }

    cards.shuffle();
    return cards;
  }

  static final List<GameLevel> allLevels = [
    // Level 1: 2 x 2 = 4 cards
    const GameLevel(
      levelNumber: 1,
      title: 'WARM UP',
      tag: 'LEVEL 01',
      rows: 2,
      cols: 2,
      totalPairs: 2,
      targetMoves: 3,
      themeColor: NeoColors.primaryYellow,
      availableCards: [
        CardItemData(emoji: '🍎', title: 'APPLE', color: NeoColors.primaryPink),
        CardItemData(emoji: '🍌', title: 'BANANA', color: NeoColors.primaryYellow),
      ],
    ),
    // Level 2: 2 x 3 = 6 cards
    const GameLevel(
      levelNumber: 2,
      title: 'ROOKIE',
      tag: 'LEVEL 02',
      rows: 3,
      cols: 2,
      totalPairs: 3,
      targetMoves: 5,
      themeColor: NeoColors.primaryCyan,
      availableCards: [
        CardItemData(emoji: '🐱', title: 'CAT', color: NeoColors.primaryPink),
        CardItemData(emoji: '🐶', title: 'DOG', color: NeoColors.primaryYellow),
        CardItemData(emoji: '🦊', title: 'FOX', color: NeoColors.primaryOrange),
      ],
    ),
    // Level 3: 4 x 2 = 8 cards
    const GameLevel(
      levelNumber: 3,
      title: 'CHALLENGER',
      tag: 'LEVEL 03',
      rows: 4,
      cols: 2,
      totalPairs: 4,
      targetMoves: 7,
      themeColor: NeoColors.primaryGreen,
      availableCards: [
        CardItemData(emoji: '🚀', title: 'ROCKET', color: NeoColors.primaryPink),
        CardItemData(emoji: '🏎️', title: 'CAR', color: NeoColors.primaryYellow),
        CardItemData(emoji: '✈️', title: 'PLANE', color: NeoColors.primaryCyan),
        CardItemData(emoji: '🚁', title: 'CHOPPER', color: NeoColors.primaryPurple),
      ],
    ),
    // Level 4: 4 x 3 = 12 cards
    const GameLevel(
      levelNumber: 4,
      title: 'MASTER',
      tag: 'LEVEL 04',
      rows: 4,
      cols: 3,
      totalPairs: 6,
      targetMoves: 10,
      themeColor: NeoColors.primaryOrange,
      availableCards: [
        CardItemData(emoji: '⚽', title: 'SOCCER', color: NeoColors.primaryGreen),
        CardItemData(emoji: '🎮', title: 'GAMING', color: NeoColors.primaryPurple),
        CardItemData(emoji: '🏀', title: 'BASKET', color: NeoColors.primaryOrange),
        CardItemData(emoji: '🎸', title: 'GUITAR', color: NeoColors.primaryPink),
        CardItemData(emoji: '🛹', title: 'SKATE', color: NeoColors.primaryYellow),
        CardItemData(emoji: '🥊', title: 'BOXING', color: NeoColors.primaryCyan),
      ],
    ),
    // Level 5: 4 x 4 = 16 cards
    const GameLevel(
      levelNumber: 5,
      title: 'GRANDMASTER',
      tag: 'LEVEL 05',
      rows: 4,
      cols: 4,
      totalPairs: 8,
      targetMoves: 14,
      themeColor: NeoColors.primaryPurple,
      availableCards: [
        CardItemData(emoji: '⚡', title: 'THUNDER', color: NeoColors.primaryYellow),
        CardItemData(emoji: '🔥', title: 'FIRE', color: NeoColors.primaryOrange),
        CardItemData(emoji: '💎', title: 'DIAMOND', color: NeoColors.primaryCyan),
        CardItemData(emoji: '🌈', title: 'RAINBOW', color: NeoColors.primaryPink),
        CardItemData(emoji: '🌟', title: 'STAR', color: NeoColors.primaryYellow),
        CardItemData(emoji: '🔮', title: 'MAGIC', color: NeoColors.primaryPurple),
        CardItemData(emoji: '🍀', title: 'CLOVER', color: NeoColors.primaryGreen),
        CardItemData(emoji: '🎯', title: 'TARGET', color: NeoColors.primaryPink),
      ],
    ),
  ];
}
