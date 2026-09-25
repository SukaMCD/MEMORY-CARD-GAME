import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../services/game_storage.dart';
import '../theme/neo_brutalism_theme.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameStorage _storage = GameStorage();

  @override
  void initState() {
    super.initState();
    _storage.addListener(_onStorageUpdate);
  }

  @override
  void dispose() {
    _storage.removeListener(_onStorageUpdate);
    super.dispose();
  }

  void _onStorageUpdate() {
    setState(() {});
  }

  int get _totalStars {
    int count = 0;
    for (var lvl in GameLevel.allLevels) {
      count += _storage.getProgress(lvl.levelNumber).stars;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: NeoBox.container(
                            color: NeoColors.primaryPink,
                            borderRadius: 6,
                            borderWidth: 2.5,
                            shadowOffset: const Offset(3, 3),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.flash_on, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'SPEED CODE EDITION',
                                style: NeoTypography.label(fontSize: 11, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        // Total Stars Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: NeoBox.container(
                            color: NeoColors.primaryYellow,
                            borderRadius: 6,
                            borderWidth: 2.5,
                            shadowOffset: const Offset(3, 3),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: NeoColors.dark, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '$_totalStars / 15 ★',
                                style: NeoTypography.label(fontSize: 12, color: NeoColors.dark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Main App Title Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: NeoBox.container(
                        color: NeoColors.surface,
                        borderRadius: 16,
                        borderWidth: 3.5,
                        shadowOffset: const Offset(6, 6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Transform.rotate(
                                angle: -0.06,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: NeoColors.primaryCyan,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: NeoColors.dark, width: 2),
                                  ),
                                  child: Text(
                                    '5 CHALLENGING LEVELS',
                                    style: NeoTypography.label(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'MEMORY\nMATCH CARD',
                            style: NeoTypography.heading(fontSize: 34),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Uji daya ingat, buka kartu, cari pasangan kartu yang cocok dengan percobaan seminimal mungkin!',
                            style: NeoTypography.body(fontSize: 13, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section Heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SELECT LEVEL',
                          style: NeoTypography.heading(fontSize: 20),
                        ),
                        Text(
                          '5 STAGES',
                          style: NeoTypography.label(fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Level List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final level = GameLevel.allLevels[index];
                    final progress = _storage.getProgress(level.levelNumber);
                    return _buildLevelCard(context, level, progress);
                  },
                  childCount: GameLevel.allLevels.length,
                ),
              ),
            ),

            // Footer Spacer & Rules note
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: NeoBox.container(
                    color: NeoColors.primaryYellow.withValues(alpha: 0.4),
                    borderRadius: 12,
                    borderWidth: 2,
                    shadowOffset: const Offset(3, 3),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates_outlined, size: 24, color: NeoColors.dark),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tips: Selesaikan level dengan percobaan sedikit untuk meraih bintang 3 dan membuka level berikutnya!',
                          style: NeoTypography.body(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    GameLevel level,
    dynamic progress,
  ) {
    final bool isUnlocked = progress.isUnlocked;
    final int stars = progress.stars;
    final int? bestMoves = progress.bestMoves;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: NeoBox.container(
        color: isUnlocked ? Colors.white : Colors.grey.shade200,
        borderRadius: 16,
        borderWidth: 3,
        shadowOffset: isUnlocked ? const Offset(5, 5) : const Offset(2, 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isUnlocked
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(level: level),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Level Number Badge
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isUnlocked ? level.themeColor : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: NeoColors.dark, width: 2.8),
                    boxShadow: const [
                      BoxShadow(
                        color: NeoColors.dark,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '0${level.levelNumber}',
                      style: NeoTypography.heading(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Level Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            level.title,
                            style: NeoTypography.heading(fontSize: 17),
                          ),
                          const Spacer(),
                          // Star display
                          if (isUnlocked)
                            Row(
                              children: List.generate(3, (starIdx) {
                                return Icon(
                                  Icons.star,
                                  size: 18,
                                  color: starIdx < stars
                                      ? NeoColors.primaryYellow
                                      : Colors.grey.shade300,
                                );
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: NeoColors.dark,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${level.rows}x${level.cols} • ${level.totalCards} CARDS',
                              style: NeoTypography.label(fontSize: 9, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (bestMoves != null)
                            Text(
                              'Best: $bestMoves moves',
                              style: NeoTypography.body(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Action Indicator (Play / Lock)
                if (isUnlocked)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NeoColors.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.dark, width: 2),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: NeoColors.dark,
                      size: 22,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.dark, width: 2),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: NeoColors.dark,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
