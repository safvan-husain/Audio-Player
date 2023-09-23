part of 'audio_bloc.dart';

@immutable
sealed class AudioEvent {}

final class AudioInitEvent extends AudioEvent {
  final List<AudioModel> audios;
  final double width;
  final int index;

  AudioInitEvent(this.audios, this.width, this.index);
}

final class AudioEndEvent extends AudioEvent {
  AudioEndEvent();
}

final class AudioPositionChangedEvent extends AudioEvent {
  final Duration currentDuration;
  AudioPositionChangedEvent(this.currentDuration);
}

final class AudioPlayerStateChangedEvent extends AudioEvent {
  final PlayerState playerState;
  AudioPlayerStateChangedEvent(this.playerState);
}

final class SwitchPlayerStateEvent extends AudioEvent {
  SwitchPlayerStateEvent();
}

final class NextMusicEvent extends AudioEvent {
  final String audioPath;
  final double width;

  NextMusicEvent(this.audioPath, this.width);
}

final class TotalDurationEvent extends AudioEvent {
  final Duration totalDuration;
  TotalDurationEvent(this.totalDuration);
}
