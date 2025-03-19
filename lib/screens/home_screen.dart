import 'package:defakeit/Themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ready to check audio authenticity?",
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
