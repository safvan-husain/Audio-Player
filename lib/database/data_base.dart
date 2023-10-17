import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDataBase {
  // Private constructor to prevent external instantiation
  MyDataBase._private();

  // Singleton instance
  static final MyDataBase _instance = MyDataBase._private();
  static late Database _db;
  // Factory constructor to return the singleton instance
  factory MyDataBase() {
    return _instance;
  }
  Database get db {
    return _db;
  }

  set setDb(Database db) {
    _db = db;
  }

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "music.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db
        .execute('CREATE TABLE Tracks (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' trackName TEXT,'
            ' trackDetail TEXT,'
            ' trackUrl TEXT,'
            ' waveformWrapper TEXT,'
            ' trackDuration INTEGER,'
            ' coverImage TEXT'
            ')');
    // Create the Playlists table
    await db
        .execute('CREATE TABLE Playlists (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' playlistName TEXT'
            ')');

    // Create the Playlist_Tracks linking table
    await db.execute('CREATE TABLE Playlist_Tracks ('
        ' playlistId INTEGER,'
        ' trackId INTEGER,'
        ' FOREIGN KEY (playlistId) REFERENCES Playlists(id),'
        ' FOREIGN KEY (trackId) REFERENCES Tracks(id)'
        ')');
    //Creating a fav playlist.
    await db.insert('Playlists', {'playlistName': 'favorites'});
  }
}
