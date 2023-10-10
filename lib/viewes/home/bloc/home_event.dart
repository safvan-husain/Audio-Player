part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class RenderTracksFromDevice extends HomeEvent {}

final class RenderTracksFromApp extends HomeEvent {}

final class RenderPlayList extends HomeEvent {
  final String playListName;

  RenderPlayList(this.playListName);
}
