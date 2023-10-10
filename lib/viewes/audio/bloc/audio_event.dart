part of 'audio_bloc.dart';

@immutable
sealed class AudioEvent {}

final class AudioInitEvent extends AudioEvent {
  final List<Track> tracks;
  final double width;
  final int index;
  final void Function() onNavigate;

  AudioInitEvent(this.tracks, this.width, this.index, this.onNavigate);
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
  final double width;
  AudioPlayerStateChangedEvent(this.playerState, this.width);
}

final class SwitchPlayerStateEvent extends AudioEvent {
  SwitchPlayerStateEvent();
}

final class ChangeMusicEvent extends AudioEvent {
  final List<Track> tracks;
  final double width;
  final int index;

  ChangeMusicEvent(this.width, this.tracks, this.index);
}

final class TotalDurationEvent extends AudioEvent {
  final Duration totalDuration;
  TotalDurationEvent(this.totalDuration);
}

final class AddTrackToFavorites extends AudioEvent {}

final class RemoveTrackFromFavorites extends AudioEvent {}
