import 'package:defakeit/Themes/theme.dart';
import 'package:flutter/material.dart';

class AnalysisHistoryScreen extends StatelessWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "AnalysisHistory",
        style: AppTheme.textTheme.displayLarge?.copyWith(
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }
}
