import 'package:flutter_bloc/flutter_bloc.dart';
import 'audio_event.dart';
import 'audio_state.dart';
import 'audio_repo.dart'; // Repository responsible for audio analysis

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepo audioRepo;

  AudioBloc({required this.audioRepo}) : super(AudioInitial());

  @override
  Stream<AudioState> mapEventToState(AudioEvent event) async* {
    if (event is AnalyzeAudioEvent) {
      yield AudioLoadingState(); // Show loading state

      try {
        final result = await audioRepo.analyzeAudio(event.audioFile);
        if (result.isFake) {
          yield AudioFakeState(result); // If fake audio is detected
        } else {
          yield AudioRealState(result); // If real audio is detected
        }
      } catch (e) {
        yield AudioErrorState("An error occurred: $e");
      }
    }
  }
}
