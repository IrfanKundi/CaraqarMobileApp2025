import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchingScreen extends StatelessWidget {
  final String label;
  final String gifPath;

  const SwitchingScreen({
    super.key,
    required this.label,
    required this.gifPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Replace Icon with Image.asset for GIF
              SizedBox(
                width: 96,
                height: 96,
                child: Image.asset(
                  gifPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
