import 'package:equatable/equatable.dart';
import '../../model/audio_result.dart';

abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoadingState extends AudioState {}

class AudioFakeState extends AudioState {
  final AudioResult result;

  const AudioFakeState(this.result);

  @override
  List<Object> get props => [result];
}

class AudioRealState extends AudioState {
  final AudioResult result;

  const AudioRealState(this.result);

  @override
  List<Object> get props => [result];
}

class AudioErrorState extends AudioState {
  final String errorMessage;

  const AudioErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
