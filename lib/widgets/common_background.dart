import 'dart:ui';

import 'package:flutter/material.dart';

class CommonBackground extends StatelessWidget {
  CommonBackground({super.key, required this.child});
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
        // Main content
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
