import 'dart:developer';

import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseService {
  // Private constructor to prevent external instantiation
  DataBaseService._private();

  // Singleton instance
  static final DataBaseService _instance = DataBaseService._private();
  static late Database _db;
  // Factory constructor to return the singleton instance
  factory DataBaseService() {
    return _instance;
  }
  Database get db {
    return _db;
  }

  ///Return Objects from [Tracks] Db column.
  Future<List<Track>> getAllTracks() async {
    List<Track> list = [];
    List<Map<String, Object?>> res = await _db.rawQuery("SELECT * FROM Tracks");
    for (var r in res) {
      print(r['trackName']);
      list.add(Track.fromMap(r));
    }
    log('get all music callled ${res.length}');
    print(res);
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

  Future<void> storeWaveForm(Track track) async {
    await _db.update(
      'Tracks',
      track.toMap(),
      where: "trackName = ?",
      whereArgs: [track.trackName],
    );
    log('wave form saved');
  }

  Future<void> deleteTrack(String trackName) async {
    await _db.delete(
      'Tracks',
      where: 'trackName = ?',
      whereArgs: [trackName],
    );
  }

  Future<bool> _checkTrackExist(String trackName) async {
    var re = await _db
        .rawQuery("SELECT * FROM Tracks WHERE trackName = '$trackName'");
    if (re.isEmpty) {
      log('track don\'t exists');
      return false;
    }
    log('track already exists');
    return true;
  }

  Future<void> init() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "music.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    log('database initialized');
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db
        .execute('CREATE TABLE Tracks (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' trackName TEXT,'
            ' trackDetail TEXT,'
            ' trackUrl TEXT,'
            ' waveformWrapper TEXT'
            ')');
  }
}
