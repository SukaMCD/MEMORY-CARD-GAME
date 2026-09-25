import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/neo_brutalism_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background elements
            _buildDecorativeCorner(
              top: 24,
              left: 20,
              icon: Icons.star_rounded,
              color: NeoColors.primaryYellow,
              rotation: -0.2,
            ),
            _buildDecorativeCorner(
              top: 40,
              right: 24,
              icon: Icons.add,
              color: NeoColors.primaryPink,
              rotation: 0.3,
            ),
            _buildDecorativeCorner(
              bottom: 40,
              left: 24,
              icon: Icons.favorite_rounded,
              color: NeoColors.primaryPink,
              rotation: 0.15,
            ),
            _buildDecorativeCorner(
              bottom: 30,
              right: 20,
              icon: Icons.bolt_rounded,
              color: NeoColors.primaryYellow,
              rotation: -0.25,
            ),

            // Main Content
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Animated Cards Badge
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value.clamp(0.0, 1.2),
                            child: Transform.rotate(
                              angle: _rotateAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Card 1: Yellow with Brain
                            Transform.rotate(
                              angle: -0.12,
                              child: _buildHeroCard(
                                color: NeoColors.primaryYellow,
                                emoji: '🧠',
                                label: 'MEMO',
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Card 2: Pink with Bolt
                            Transform.rotate(
                              angle: 0.12,
                              child: _buildHeroCard(
                                color: NeoColors.primaryPink,
                                emoji: '⚡',
                                label: 'MATCH',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Top Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: NeoBox.container(
                          color: NeoColors.primaryCyan,
                          borderRadius: 8,
                          borderWidth: 2.5,
                          shadowOffset: const Offset(3, 3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flash_on,
                                color: NeoColors.dark, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'SPEED CODE CHALLENGE',
                              style: NeoTypography.label(
                                fontSize: 11,
                                color: NeoColors.dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // App Title
                      Text(
                        'MEMORY\nMATCH CARD',
                        textAlign: TextAlign.center,
                        style: NeoTypography.heading(
                          fontSize: 36,
                          color: NeoColors.dark,
                        ).copyWith(height: 1.05),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'NEO-BRUTALISM EDITION',
                        style: NeoTypography.label(
                          fontSize: 12,
                          color: NeoColors.dark.withValues(alpha: 0.7),
                        ),
                      ),

                      const Spacer(),

                      // Custom Neo Progress Bar
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, _) {
                          final progress = _progressAnimation.value;
                          final percentage = (progress * 100).toInt();

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    progress < 0.95
                                        ? 'SHUFFLING CARDS...'
                                        : 'GET READY!',
                                    style: NeoTypography.label(fontSize: 11),
                                  ),
                                  Text(
                                    '$percentage%',
                                    style: NeoTypography.heading(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 22,
                                width: double.infinity,
                                decoration: NeoBox.container(
                                  color: Colors.white,
                                  borderRadius: 11,
                                  borderWidth: 3,
                                  shadowOffset: const Offset(3, 3),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: progress.clamp(0.02, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: NeoColors.primaryGreen,
                                        border: const Border(
                                          right: BorderSide(
                                            color: NeoColors.dark,
                                            width: 2.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 36),
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

  Widget _buildHeroCard({
    required Color color,
    required String emoji,
    required String label,
  }) {
    return Container(
      width: 90,
      height: 120,
      decoration: NeoBox.container(
        color: color,
        borderRadius: 14,
        borderWidth: 3.5,
        shadowOffset: const Offset(5, 5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 38),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: NeoColors.dark, width: 2),
            ),
            child: Text(
              label,
              style: NeoTypography.label(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required IconData icon,
    required Color color,
    required double rotation,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: rotation * math.pi,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: NeoBox.container(
            color: color,
            borderRadius: 10,
            borderWidth: 2.5,
            shadowOffset: const Offset(3, 3),
          ),
          child: Icon(icon, color: NeoColors.dark, size: 20),
        ),
      ),
    );
  }
}
