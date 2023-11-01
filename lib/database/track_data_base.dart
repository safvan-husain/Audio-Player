import 'dart:developer';
import 'dart:io';

import 'package:audio_player/common/waveform_extension.dart';
import 'package:audio_player/database/data_base.dart';
import 'package:audio_player/common/track_model.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

mixin TrackDataBase {
  final Database _db = MyDataBase().db;

  Future<void> deleteAll() async {
    // Delete all rows from the Tracks table
    await _db.rawDelete('DELETE FROM Tracks');

    // Delete all rows from the Playlists table
    await _db.rawDelete('DELETE FROM Playlists');

    // Delete all rows from the Playlist_Tracks table
    await _db.rawDelete('DELETE FROM Playlist_Tracks');
  }

  ///Return Objects from [Tracks] Db column.
  Future<List<Track>> getAllTracks() async {
    List<Track> list = [];
    List<Map<String, Object?>> res = await _db.rawQuery("SELECT * FROM Tracks");
    for (var r in res) {
      list.add(Track.fromMap(r));
    }
    return list;
  }

  Future<Future<Track> Function()?> insertTrack(
      Track track, void Function() updateHome) async {
    if (!await _checkTrackExist(track.trackName)) {
      await _db.insert(
        'Tracks',
        track.toMap(),
      );
      return () => _generateWaveForm(track, updateHome);
    }
    return null;
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

  Future<Track> _generateWaveForm(
      Track track, void Function() updateHome) async {
    final audioFile = File(track.trackUrl);
    try {
      final waveFile = File(join(
          (await getTemporaryDirectory()).path, '${track.trackName}.wave'));

      JustWaveform.extract(audioInFile: audioFile, waveOutFile: waveFile)
          .listen((data) {
        if (data.waveform != null) {
          track.waveformWrapper = WaveformWrapper(data.waveform!);
          storeWaveForm(track, () {
            log('waveform stored for ${track.trackName}');
            updateHome();
          });
        }
      }, onError: (e) {
        throw ('error getting wave $e');
      });
    } catch (e) {
      print(e);
    }
    return track;
  }
}
