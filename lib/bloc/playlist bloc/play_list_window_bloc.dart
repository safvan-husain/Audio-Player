import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/bloc/home bloc/home_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'play_list_window_event.dart';
part 'play_list_window_state.dart';

class PlayListWindowBloc
    extends Bloc<PlayListWindowEvent, PlayListWindowState> {
  final HomeBloc _homeBloc;
  PlayListWindowBloc(this._homeBloc) : super(PlayListWindowInitial()) {
    DataBaseService dataBaseService = DataBaseService();
    on<LoadPlayLists>((event, emit) async {
      List<String> possiblePlayLists =
          await dataBaseService.getAllPlayListName();
      List<String> currentPlayLists =
          await dataBaseService.getPlaylistsForTrack(event.trackName);
      emit(PlayListsLoadedState(
        trackName: event.trackName,
        possiblePlaylists: possiblePlayLists,
        currentPlayLists: currentPlayLists,
      ));
      event.showPopUp();
    });

    on<ShowInputField>((event, emit) {
      emit(InputTextState(
          trackName: state.trackName,
          possiblePlaylists: state.possiblePlaylists,
          currentPlayLists: state.currentPlayLists));
    });

    on<CreateNewPlayList>((event, emit) async {
      await dataBaseService.createPlayList(event.playListName);
      _homeBloc.add(ListPlayLists());
      await dataBaseService.addTrackToPlayList(
        state.trackName,
        event.playListName,
      );
      emit(PlayListsLoadedState(
          trackName: state.trackName,
          possiblePlaylists: [...state.possiblePlaylists, event.playListName],
          currentPlayLists: [...state.currentPlayLists, event.playListName]));
    });
    on<AddedToPlayList>((event, emit) async {
      await dataBaseService.addTrackToPlayList(
        event.trackName,
        event.playListName,
      );
      emit(PlayListsLoadedState(
        trackName: event.trackName,
        possiblePlaylists: state.possiblePlaylists,
        currentPlayLists: [...state.currentPlayLists, event.playListName],
      ));
    });

    on<RemoveFromPlayList>((event, emit) async {
      await dataBaseService.removeTrackFromPlaylist(
        event.trackName,
        event.playListName,
      );
      var current = state.currentPlayLists;
      current.remove(event.playListName);
      emit(PlayListsLoadedState(
        trackName: event.trackName,
        possiblePlaylists: state.possiblePlaylists,
        currentPlayLists: current,
      ));
    });
    on<AddTrackToFavorites>((event, emit) async {
      await dataBaseService.addTrackToFavorites(event.trackName);
      var current = state.currentPlayLists;
      emit(PlayListsLoadedState(
        trackName: event.trackName,
        possiblePlaylists: state.possiblePlaylists,
        currentPlayLists: current,
      ));
    });
    on<RemoveTrackFromFavorites>((event, emit) async {
      await dataBaseService.addTrackToFavorites(event.trackName);
      var current = state.currentPlayLists;
      emit(PlayListsLoadedState(
        trackName: event.trackName,
        possiblePlaylists: state.possiblePlaylists,
        currentPlayLists: current,
      ));
    });
  }
}
