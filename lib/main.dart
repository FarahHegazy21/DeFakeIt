import 'package:defakeit/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'features/home/logic/audio_bloc/audio_repo.dart';
import 'features/home/logic/home_bloc/home_bloc.dart'; // افترض أنك تستخدم هذا الملف للتنقل

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => HomeBloc(AudioRepo())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute, // استخدم generateRoute هنا
      initialRoute: '/home', // تعيين المسار الأول عند بدء التطبيق
    );
  }
}
