part of 'audio_bloc.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class InitializeAudio extends AudioEvent {
  final Book book;

  const InitializeAudio({required this.book});
}

class SkipSeconds extends AudioEvent {
  final int seconds;

  const SkipSeconds({required this.seconds});
}

class SleepMode extends AudioEvent {
  final TimeOfDay time;
  final Function(BuildContext) function;

  const SleepMode({required this.time, required this.function});
}
