part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final List<AudioModel> audioList;

  const HomeState({this.audioList = const []});
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required super.audioList});
}
