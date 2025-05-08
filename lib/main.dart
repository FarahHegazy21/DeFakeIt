import 'package:defakeit/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/theme.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/auth/logic/auth_event.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/home/data/service/audio_service.dart';
import 'features/home/logic/home_bloc/home_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(audioService: AudioService())),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()..add(AppStarted())),
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
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/splash',
    );
  }
}
