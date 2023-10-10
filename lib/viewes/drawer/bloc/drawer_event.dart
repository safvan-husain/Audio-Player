part of 'drawer_bloc.dart';

@immutable
sealed class DrawerEvent {}

final class SwitchPlayListExtendedness extends DrawerEvent {}

final class SwitchPreferencesExtendedness extends DrawerEvent {}

final class ListPlayLists extends DrawerEvent {}

final class OnPlayListTap extends DrawerEvent {
  final String playListName;

  OnPlayListTap(this.playListName);
}
