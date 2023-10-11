part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final List<Track> trackList;
  final String playList;

  const HomeState({this.trackList = const [], this.playList = "All"});
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required super.trackList, super.playList});
}
