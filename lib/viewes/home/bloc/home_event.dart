part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class RenderTracksFromDevice extends HomeEvent {}

final class RenderTracksFromApp extends HomeEvent {}
