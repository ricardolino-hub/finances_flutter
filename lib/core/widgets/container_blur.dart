import 'dart:ui';

import 'package:flutter/widgets.dart';

class BlurIfNeeded extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const BlurIfNeeded({super.key, required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: child,
      ),
    );
  }
}