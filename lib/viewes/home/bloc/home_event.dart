part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class RenderTracksFromDevice extends HomeEvent {}

final class RenderTracksFromApp extends HomeEvent {}

final class RenderPlayList extends HomeEvent {
  final String playListName;

  RenderPlayList(this.playListName);
}

final class Favorite extends HomeEvent {
  final bool isFavorite;
  final String trackName;
  Favorite(this.isFavorite, this.trackName);

  // factory Favorite.add() {
  //   return Favorite(true);
  // }

  // factory Favorite.remove() {
  //   return Favorite(false);
  // }
}
