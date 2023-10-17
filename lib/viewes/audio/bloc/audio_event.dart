part of 'audio_bloc.dart';

@immutable
sealed class AudioEvent {}

final class AudioInitEvent extends AudioEvent {
  final List<Track> tracks;
  final int currentIndex;
  final double width;

  AudioInitEvent(this.tracks, this.currentIndex, this.width);
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
  final int currentIndex;
  final double width;

  ChangeMusicEvent(this.tracks, this.currentIndex, this.width);

  factory ChangeMusicEvent.next(AudioState state, double width) {
    return ChangeMusicEvent(
        state.tracks,
        //if the length exceed start from 0.
        state.tracks.length - 1 > state.currentIndex
            ? state.currentIndex + 1
            : 0,
        width);
  }

  factory ChangeMusicEvent.previous(AudioState state, double width) {
    return ChangeMusicEvent(
        state.tracks,
        //if the length exceed start from last.
        state.currentIndex > 0
            ? state.currentIndex - 1
            : state.tracks.length - 1,
        width);
  }
}

final class TotalDurationEvent extends AudioEvent {
  final Duration totalDuration;
  TotalDurationEvent(this.totalDuration);
}

final class AddTrackToFavorites extends AudioEvent {}

final class RemoveTrackFromFavorites extends AudioEvent {}

final class SwitchShuffle extends AudioEvent {}

final class PlayListPlayerStateSwitch extends AudioEvent {
  final List<Track> tracks;
  final double width;

  PlayListPlayerStateSwitch(this.tracks, this.width);
}
