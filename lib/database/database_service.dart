import 'dart:developer';

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
  Future<List<String>> getAllMusic() async {
    List<String> list = [];
    List<Map<String, Object?>> res =
        await _db.rawQuery("SELECT * FROM music_path");
    for (var r in res) {
      list.add(r['path'] as String);
      print(list);
    }
    return list;
  }

  Future<void> insertMusicPath(String path) async {
    if (!await _checkPathExist(path)) {
      await _db.insert(
        'music_path',
        {'path': path},
      );
    }
  }

  Future<void> deleteMusicPath(String path) async {
    await _db.delete(
      'music_path',
      where: 'path = ?',
      whereArgs: [path],
    );
  }

  Future<bool> _checkPathExist(String path) async {
    var re =
        await _db.rawQuery("SELECT * FROM music_path WHERE path = '$path'");
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
        ' path TEXT'
        ')');
  }
}
