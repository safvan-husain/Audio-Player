import 'dart:developer';

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

  ///Return Objects from [music_path] Db column.
  Future<List<AudioModel>> getAllMusic() async {
    List<AudioModel> list = [];
    List<Map<String, Object?>> res =
        await _db.rawQuery("SELECT * FROM music_path");
    for (var r in res) {
      list.add(AudioModel.fromMap(r));
    }
    print(res);
    return list;
  }

  Future<void> insertMusicPath(AudioModel audio) async {
    if (!await _checkPathExist(audio.audioPath)) {
      await _db.insert(
        'music_path',
        audio.toMap(),
      );
    }
  }

  Future<void> storeWaveForm(AudioModel audio) async {
    await _db.update(
      'music_path',
      audio.toMap(),
      where: "audioPath = ?",
      whereArgs: [audio.audioPath],
    );
    log('wave form saved');
  }

  Future<void> deleteMusicPath(String path) async {
    await _db.delete(
      'music_path',
      where: 'audioPath = ?',
      whereArgs: [path],
    );
  }

  Future<bool> _checkPathExist(String path) async {
    var re = await _db
        .rawQuery("SELECT * FROM music_path WHERE audioPath = '$path'");
    if (re.isEmpty) {
      return false;
    }
    log('music path already exists');
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
    await db.execute(
        'CREATE TABLE music_path (id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' audioPath TEXT,'
        ' waveformWrapper TEXT'
        ')');
  }
}
