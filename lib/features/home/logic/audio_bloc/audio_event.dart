import 'package:equatable/equatable.dart';
import 'dart:io'; // for File type

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class AnalyzeAudioEvent extends AudioEvent {
  final File audioFile;

  const AnalyzeAudioEvent(this.audioFile);

  @override
  List<Object> get props => [audioFile];
}
