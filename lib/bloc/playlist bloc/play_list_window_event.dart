// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'play_list_window_bloc.dart';

@immutable
sealed class PlayListWindowEvent {}

class LoadPlayLists extends PlayListWindowEvent {
  final String trackName;
  final void Function() showPopUp;
  LoadPlayLists(this.trackName, this.showPopUp);
}

class AddedToPlayList extends PlayListWindowEvent {
  final String trackName;
  final String playListName;

  AddedToPlayList(this.trackName, this.playListName);
}

class RemoveFromPlayList extends PlayListWindowEvent {
  final String trackName;
  final String playListName;

  RemoveFromPlayList(this.trackName, this.playListName);
}

class AddTrackToFavorites extends PlayListWindowEvent {
  final String trackName;

  AddTrackToFavorites(this.trackName);
}

class RemoveTrackFromFavorites extends PlayListWindowEvent {
  final String trackName;

  RemoveTrackFromFavorites(this.trackName);
}

class ShowInputField extends PlayListWindowEvent {}

class CreateNewPlayList extends PlayListWindowEvent {
  final String playListName;

  CreateNewPlayList(this.playListName);
}
