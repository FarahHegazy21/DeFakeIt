import 'package:defakeit/Themes/theme.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Setting",
        style: AppTheme.textTheme.displayLarge?.copyWith(
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }
}
