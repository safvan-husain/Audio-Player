part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final List<String> audioPaths;

  const HomeState({this.audioPaths = const []});
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required super.audioPaths});
}
