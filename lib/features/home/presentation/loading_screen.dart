import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.001;
        if (_progress >= 1.0) {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Analyzing Audio...",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 30),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 10.0,
                percent: _progress.clamp(0.0, 1.0),
                center: Text("${(_progress * 100).toStringAsFixed(0)}%"),
                progressColor: const Color(0xFF3E3C6D),
                backgroundColor: Colors.grey.shade300,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(height: 30),
              const Text("Loading...", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
