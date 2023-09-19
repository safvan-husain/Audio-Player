part of 'audio_bloc.dart';

@immutable
sealed class AudioEvent {}

final class AudioInitEvent extends AudioEvent {
  final String audioPath;
  final double width;

  AudioInitEvent(this.audioPath, this.width);
}

final class AudioEndEvent extends AudioEvent {
  AudioEndEvent();
}
