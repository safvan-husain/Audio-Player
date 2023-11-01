part of 'audio_bloc.dart';

enum ChangeType {
  currentDuration,
  totalDuration,
  initial,
  end,
  playerState,
  trackLoaded,
  shuffle,
  wave1,
  wave2
}

// @immutable
class AudioState {
  final ChangeType changeType;
  final int currentIndex;
  final List<Track> tracks;

  final AudioPlayerHandler audioHandler;
  final Duration currentDuration;
  BehaviorSubject<WaveformProgress> progressStream;
  PlayerState playerState;
  bool isShuffling;

  AudioState({
    required this.changeType,
    required this.audioHandler,
    required this.currentDuration,
    required this.playerState,
    required this.currentIndex,
    required this.progressStream,
    required this.tracks,
    required this.isShuffling,
  });
  AudioState copyWith({
    required ChangeType changeType,
    AudioPlayerHandler? audioHandler,
    Duration? currentDuration,
    PlayerState? isPlaying,
    Duration? totalDuration,
    int? currentIndex,
    BehaviorSubject<WaveformProgress>? progressStream,
    List<Track>? tracks,
    bool? isShuffling,
  }) {
    return AudioState(
      changeType: changeType,
      audioHandler: audioHandler ?? this.audioHandler,
      currentDuration: currentDuration ?? this.currentDuration,
      currentIndex: currentIndex ?? this.currentIndex,
      progressStream: progressStream ?? this.progressStream,
      tracks: tracks ?? this.tracks,
      playerState: isPlaying ?? playerState,
      isShuffling: isShuffling ?? this.isShuffling,
    );
  }

  AudioState end() {
    return AudioState(
      changeType: ChangeType.end,
      audioHandler: audioHandler,
      currentDuration: Duration.zero,
      playerState: PlayerState.disposed,
      currentIndex: currentIndex,
      progressStream: progressStream,
      tracks: tracks,
      isShuffling: isShuffling,
    );
  }

  factory AudioState.initial(AudioPlayerHandler audioHandler) {
    return AudioState(
      changeType: ChangeType.initial,
      currentDuration: Duration.zero,
      audioHandler: audioHandler,
      currentIndex: 0,
      progressStream: BehaviorSubject<WaveformProgress>(),
      tracks: [],
      playerState: PlayerState.paused,
      isShuffling: true,
    );
  }
}
