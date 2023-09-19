part of 'audio_bloc.dart';

// @immutable
sealed class AudioState {
  final PlayerController? controller;
  int currentDuration;
  AudioState({this.controller, required this.currentDuration});
}

final class AudioInitial extends AudioState {
  AudioInitial({required super.currentDuration});
}

final class AudioEndState extends AudioState {
  AudioEndState({super.controller, required super.currentDuration});
}

final class AudioLoadedState extends AudioState {
  AudioLoadedState({
    required super.controller,
    required super.currentDuration,
  });
}
