import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleState {
  final Locale locale;
  LocaleState(this.locale);
}

abstract class LocaleEvent {}

class ChangeLocale extends LocaleEvent {
  final String languageCode;
  ChangeLocale(this.languageCode);
}

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState(const Locale('en'))) {
    _loadLocale();

    on<ChangeLocale>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', event.languageCode);
      emit(LocaleState(Locale(event.languageCode)));
    });
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    add(ChangeLocale(languageCode));
  }
}
