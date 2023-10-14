part of 'audio_bloc.dart';

enum ChangeType {
  currentDuration,
  totalDuration,
  initial,
  end,
  playerState,
  trackLoaded,
  shuffle
}

// @immutable
class AudioState {
  final ChangeType changeType;
  final int currentIndex;
  final List<Track> tracks;

  final AudioPlayer? controller;
  final Duration currentDuration;
  final Duration totalDuration;
  BehaviorSubject<WaveformProgress> progressStream;
  bool isPlaying;
  bool isShuffling;

  AudioState({
    required this.changeType,
    required this.controller,
    required this.currentDuration,
    required this.isPlaying,
    required this.totalDuration,
    required this.currentIndex,
    required this.progressStream,
    required this.tracks,
    required this.isShuffling,
  });
  AudioState copyWith({
    required ChangeType changeType,
    AudioPlayer? controller,
    Duration? currentDuration,
    bool? isPlaying,
    Duration? totalDuration,
    int? currentIndex,
    BehaviorSubject<WaveformProgress>? progressStream,
    List<Track>? tracks,
    bool? isShuffling,
  }) {
    return AudioState(
      changeType: changeType,
      controller: controller ?? this.controller,
      currentDuration: currentDuration ?? this.currentDuration,
      totalDuration: totalDuration ?? this.totalDuration,
      currentIndex: currentIndex ?? this.currentIndex,
      progressStream: progressStream ?? this.progressStream,
      tracks: tracks ?? this.tracks,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffling: isShuffling ?? this.isShuffling,
    );
  }

  AudioState end() {
    return AudioState(
      changeType: ChangeType.end,
      controller: null,
      currentDuration: Duration.zero,
      isPlaying: false,
      totalDuration: Duration.zero,
      currentIndex: currentIndex,
      progressStream: progressStream,
      tracks: tracks,
      isShuffling: isShuffling,
    );
  }

  factory AudioState.initial() {
    return AudioState(
      changeType: ChangeType.initial,
      currentDuration: Duration.zero,
      totalDuration: Duration.zero,
      controller: null,
      currentIndex: 0,
      progressStream: BehaviorSubject<WaveformProgress>(),
      tracks: [],
      isPlaying: false,
      isShuffling: true,
    );
  }
}
