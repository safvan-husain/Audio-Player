part of 'audio_bloc.dart';

// @immutable
sealed class AudioState {
  final int currentIndex;
  final List<Track> tracks;

  final AudioPlayer? controller;
  final Duration currentDuration;
  final Duration totalDuration;
  BehaviorSubject<WaveformProgress> progressStream;
  bool isPlaying;
  AudioState({
    required this.controller,
    required this.currentDuration,
    this.isPlaying = true,
    required this.totalDuration,
    required this.currentIndex,
    required this.progressStream,
    required this.tracks,
  });
}

final class AudioInitial extends AudioState {
  AudioInitial({
    required super.controller,
    super.currentDuration = Duration.zero,
    super.totalDuration = Duration.zero,
    required super.currentIndex,
    required super.progressStream,
    required super.tracks,
  });
}

final class AudioEndState extends AudioState {
  AudioEndState({
    required super.controller,
    required super.currentDuration,
    required super.totalDuration,
    required super.currentIndex,
    required super.progressStream,
    required super.tracks,
  });
}

final class AudioLoadedState extends AudioState {
  AudioLoadedState({
    required super.controller,
    required super.currentDuration,
    required super.totalDuration,
    required super.currentIndex,
    required super.progressStream,
    required super.tracks,
  });
}

final class AudioPositionChangedState extends AudioState {
  AudioPositionChangedState({
    required super.controller,
    required super.currentDuration,
    required super.totalDuration,
    required super.currentIndex,
    required super.progressStream,
    required super.tracks,
  });
}

final class AudioPlayerStateChangedState extends AudioState {
  AudioPlayerStateChangedState({
    required super.controller,
    required super.isPlaying,
    required super.currentDuration,
    required super.totalDuration,
    required super.currentIndex,
    required super.progressStream,
    required super.tracks,
  });
}

final class TotalDurationState extends AudioState {
  TotalDurationState({
    required super.controller,
    required super.currentDuration,
    required super.totalDuration,
    required super.currentIndex,
    required super.progressStream,
    required super.tracks,
  });
}
