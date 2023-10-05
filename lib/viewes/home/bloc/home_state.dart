part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final List<Track> trackList;

  const HomeState({this.trackList = const []});
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required super.trackList});
}
