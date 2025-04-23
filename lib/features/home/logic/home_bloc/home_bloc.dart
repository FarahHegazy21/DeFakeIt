import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/audio_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AudioRepo audioRepo;

  HomeBloc({required this.audioRepo}) : super(HomeInitial()) {
    on<StartAnalysis>(_onStartAnalysis);
    on<AudioPicked>(_onAudioPicked);
    on<ClearPickedAudio>(_onClearPickedAudio);
  }

  Future<void> _onAudioPicked(
    AudioPicked event,
    Emitter<HomeState> emit,
  ) async {
    emit(AudioPickedState(event.audioFile, event.fileName));
  }

  Future<void> _onStartAnalysis(
      StartAnalysis event, Emitter<HomeState> emit) async {
    emit(AnalyzingState());

    try {
      final file = event.audioFile;

      if (!await file.exists()) {
        emit(ErrorState("File does not exist."));
        return;
      }

      if (await file.length() == 0) {
        emit(ErrorState("Audio file is empty."));
        return;
      }

      final result = await audioRepo
          .analyzeAudio(file)
          .timeout(const Duration(seconds: 15));
      emit(AnalysisResultState(result.isFake, result.confidence));
    } catch (e, stackTrace) {
      emit(ErrorState("Analysis failed: ${e.toString()}"));
      return;
    }
  }

  void _onClearPickedAudio(
    ClearPickedAudio event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeInitial());
  }
}
