part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class AudioPickedState extends HomeState {
  final File audioFile;
  final String fileName;

  const AudioPickedState(this.audioFile, this.fileName);

  @override
  List<Object> get props => [audioFile, fileName];
}

class AnalyzingState extends HomeState {}

class AnalysisResultState extends HomeState {
  final bool isFake;
  final double confidence;

  const AnalysisResultState(this.isFake, this.confidence);

  @override
  List<Object> get props => [isFake, confidence];
}

class ErrorState extends HomeState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
