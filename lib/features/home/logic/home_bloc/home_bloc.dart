import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../audio_bloc/audio_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AudioRepo audioRepo;

  HomeBloc(this.audioRepo) : super(HomeInitial()) {
    on<AudioPicked>(_onAudioPicked);
    on<StartAnalysis>(_onStartAnalysis);
    on<AnalysisFailed>(_onAnalysisFailed);
    on<ClearPickedAudio>(_onClearPickedAudio);
  }

  Future<void> _onAudioPicked(
    AudioPicked event,
    Emitter<HomeState> emit,
  ) async {
    emit(AudioPickedState(event.audioFile, event.fileName));
  }

  Future<void> _onStartAnalysis(
    StartAnalysis event,
    Emitter<HomeState> emit,
  ) async {
    emit(AnalyzingState());

    try {
      final result = await audioRepo.analyzeAudio(event.audioFile);
      emit(AnalysisResultState(result.isFake, result.confidence));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onAnalysisFailed(
    AnalysisFailed event,
    Emitter<HomeState> emit,
  ) async {
    emit(ErrorState(event.message));
  }

  void _onClearPickedAudio(
    ClearPickedAudio event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeInitial());
  }
}
