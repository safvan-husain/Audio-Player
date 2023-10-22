import 'package:audio_player/database/data_base.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:sqflite/sqflite.dart';

mixin TrackDataBase {
  final Database _db = MyDataBase().db;

  ///Return Objects from [Tracks] Db column.
  Future<List<Track>> getAllTracks() async {
    List<Track> list = [];
    List<Map<String, Object?>> res = await _db.rawQuery("SELECT * FROM Tracks");
    for (var r in res) {
      list.add(Track.fromMap(r));
    }
    return list;
  }

  Future<void> insertTrack(Track track) async {
    if (!await _checkTrackExist(track.trackName)) {
      await _db.insert(
        'Tracks',
        track.toMap(),
      );
    }
  }

  Future<void> deleteNonExistentTracks(List<Track> tracks) async {
    List<Track> allTracks = await getAllTracks();

    List<String> trackNames = tracks.map((track) => track.trackName).toList();

    // Filter out the tracks that are not in the given list
    List<Track> tracksToDelete = allTracks
        .where((track) => !trackNames.contains(track.trackName))
        .toList();

    for (var track in tracksToDelete) {
      await deleteTrack(track.trackName);
    }
  }

  Future<void> storeWaveForm(Track track, void Function() onSaved) async {
    await _db.update(
      'Tracks',
      track.toMap(),
      where: "trackName = ?",
      whereArgs: [track.trackName],
    );
    onSaved();
  }

  Future<void> deleteTrack(String trackName) async {
    if (await _checkTrackExist(trackName)) {
      await _db.delete(
        'Tracks',
        where: 'trackName = ?',
        whereArgs: [trackName],
      );
    } else {
      throw ('track not found');
    }
  }

  Future<void> deleteAllTracks() async {
    List<Map<String, Object?>> res = await _db.rawQuery("SELECT * FROM Tracks");
    for (var r in res) {
      deleteTrack(r['trackName'] as String);
    }
  }

  Future<bool> _checkTrackExist(String trackName) async {
    var re = await _db
        .rawQuery("SELECT * FROM Tracks WHERE trackName = '$trackName'");
    if (re.isEmpty) {
      return false;
    }
    return true;
  }
}
