part of 'audio_bloc.dart';

abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioInitialized extends AudioState {
  final AudioPlayer audioPlayer;

  const AudioInitialized({required this.audioPlayer});
}

class AudioError extends AudioState {
  final String message;

  const AudioError({required this.message});
}
