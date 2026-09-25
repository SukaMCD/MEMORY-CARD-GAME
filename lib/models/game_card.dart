import 'package:flutter/material.dart';

class GameCard {
  final String id;
  final int pairId;
  final String emoji;
  final String title;
  final Color accentColor;
  bool isFaceUp;
  bool isMatched;

  GameCard({
    required this.id,
    required this.pairId,
    required this.emoji,
    required this.title,
    required this.accentColor,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  GameCard copyWith({
    String? id,
    int? pairId,
    String? emoji,
    String? title,
    Color? accentColor,
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return GameCard(
      id: id ?? this.id,
      pairId: pairId ?? this.pairId,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      accentColor: accentColor ?? this.accentColor,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
