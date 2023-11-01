import 'package:audio_player/database/play_list_data_base.dart';
import 'package:audio_player/database/track_data_base.dart';
import 'package:audio_player/model/track_model.dart';

class DataBaseService with TrackDataBase, PlayListDataBase {
  // Private constructor to prevent external instantiation
  DataBaseService._private();

  // Singleton instance
  static final DataBaseService _instance = DataBaseService._private();

  // Factory constructor to return the singleton instance
  factory DataBaseService() {
    return _instance;
  }

  Future<List<String>> getAllFavorites() async {
    List<Track> favorites = await getTracksFromPlayList('favorites');
    return favorites.map((e) => e.trackName).toList();
  }

//PlayList linking methods.
  Future<void> addTrackToFavorites(String trackName) async {
    await addTrackToPlayList(trackName, 'favorites');
  }

  Future<void> removeFromFavorite(String trackName) async {
    await removeTrackFromPlaylist(trackName, 'favorites');
  }
}
