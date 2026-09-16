import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:streamit_laravel/utils/colors.dart';

class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // ENTRY: Fade + scale
    final enter = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

    // EXIT: Page itself dissolves away
    final exit = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);

    return AnimatedBuilder(
      animation: Listenable.merge([enter, exit]),
      builder: (_, __) {
        return Stack(
          children: [
            // PAGE → fades + scales in
            FadeTransition(
              opacity: enter,
              child: ScaleTransition(
                scale: Tween(begin: 0.97, end: 1.0).animate(enter),
                child: FadeTransition(
                  // IMPORTANT
                  opacity: Tween(begin: 1.0, end: 0.0).animate(exit),
                  child: child,
                ),
              ),
            ),

            // VIGNETTE + BLUR dissolving overlay
            if (exit.value > 0)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: exit.value * 8, sigmaY: exit.value * 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.4,
                      colors: [
                        appScreenBackgroundDark.withValues(alpha: exit.value * 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}