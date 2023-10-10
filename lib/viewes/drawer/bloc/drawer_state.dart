part of 'drawer_bloc.dart';

@immutable
sealed class DrawerState {
  final List<String> playLists;
  final bool isPlayListExtended;

  const DrawerState({
    required this.playLists,
    required this.isPlayListExtended,
  });
}

final class DrawerInitial extends DrawerState {
  const DrawerInitial({
    super.playLists = const [],
    super.isPlayListExtended = false,
  });
}

final class DrawerStateChange extends DrawerState {
  const DrawerStateChange({
    required super.playLists,
    required super.isPlayListExtended,
  });
}
