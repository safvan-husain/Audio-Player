part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final List<Track> trackList;
  final List<String> playLists;
  final bool onHome;

  const HomeState({
    this.trackList = const [],
    this.playLists = const [],
    this.onHome = true,
  });
  copyWith({List<Track>? tracks, List<String>? playLists}) {}
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required super.trackList, required super.playLists});
  @override
  HomeLoaded copyWith({List<Track>? tracks, List<String>? playLists}) {
    return HomeLoaded(
      trackList: tracks ?? trackList,
      playLists: playLists ?? this.playLists,
    );
  }
}

final class PlayListLoaded extends HomeState {
  const PlayListLoaded({required super.trackList, required super.playLists});
  @override
  PlayListLoaded copyWith({List<Track>? tracks, List<String>? playLists}) {
    return PlayListLoaded(
      trackList: tracks ?? trackList,
      playLists: playLists ?? this.playLists,
    );
  }
}

final class PlayListRendered extends HomeState {
  const PlayListRendered({
    required super.trackList,
    required super.playLists,
    super.onHome = false,
  });
  @override
  PlayListRendered copyWith({List<Track>? tracks, List<String>? playLists}) {
    return PlayListRendered(
      trackList: tracks ?? trackList,
      playLists: playLists ?? this.playLists,
    );
  }
}
