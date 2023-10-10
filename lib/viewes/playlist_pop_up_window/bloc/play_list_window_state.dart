part of 'play_list_window_bloc.dart';

@immutable
sealed class PlayListWindowState {
  final String trackName;
  final List<String> possiblePlaylists;
  final List<String> currentPlayLists;

  const PlayListWindowState({
    this.trackName = '',
    this.possiblePlaylists = const [],
    this.currentPlayLists = const [],
  });
}

final class PlayListWindowInitial extends PlayListWindowState {}

final class PlayListsLoadedState extends PlayListWindowState {
  const PlayListsLoadedState({
    required super.trackName,
    required super.possiblePlaylists,
    super.currentPlayLists = const [],
  });
}

final class InputTextState extends PlayListWindowState {
  const InputTextState({
    required super.trackName,
    required super.possiblePlaylists,
    super.currentPlayLists = const [],
  });
}
