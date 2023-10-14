import 'dart:developer';

import 'package:audio_player/services/track_model.dart';
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

  Future<void> storeWaveForm(Track track, void Function() onSaved) async {
    await _db.update(
      'Tracks',
      track.toMap(),
      where: "trackName = ?",
      whereArgs: [track.trackName],
    );
    onSaved();
    log('wave form saved');
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

  Future<bool> _checkTrackExist(String trackName) async {
    var re = await _db
        .rawQuery("SELECT * FROM Tracks WHERE trackName = '$trackName'");
    if (re.isEmpty) {
      return false;
    }
    return true;
  }

  //Play List Methods.
  Future<List<String>> getAllPlayListName() async {
    var re = await _db.rawQuery("SELECT * FROM Playlists");
    return re.map((e) => e['playlistName'] as String).toList();
  }

  Future<void> createPlayList(String playListName) async {
    if (!await _checkPlayListExist(playListName)) {
      await _db.insert('Playlists', {"playlistName": playListName});
    }
  }

  Future<void> deletePlayList(String playListName) async {
    await _db.delete(
      'Playlists',
      where: 'playlistName = ?',
      whereArgs: [playListName],
    );
  }

  Future<List<Track>> getTracksFromPlayList(String playListName) async {
    var playlistId = await _db.query('Playlists',
        where: 'playlistName = ?', whereArgs: [playListName]);
    if (playlistId.isEmpty) {
      return [
        Track(
          trackDetail: "Safvan",
          trackName: "Safvan's Speech",
          trackUrl: '/',
        )
      ];
    }
    var result = await _db.rawQuery(
        'SELECT * FROM Tracks INNER JOIN Playlist_Tracks ON Tracks.id = Playlist_Tracks.trackId WHERE Playlist_Tracks.playlistId = ?',
        [playlistId[0]['id']]);
    List<Track> res = [];
    for (var r in result) {
      res.add(Track.fromMap(r));
    }
    return res;
  }

  Future<bool> _checkPlayListExist(String playListName) async {
    var re = await _db.rawQuery(
        "SELECT * FROM Playlists WHERE playlistName = '$playListName'");
    if (re.isEmpty) {
      log('track don\'t exists');
      return false;
    }
    log('track already exists');
    return true;
  }

  Future<List<String>> getAllFavorites() async {
    List<Track> favorites = await getTracksFromPlayList('favorites');
    return favorites.map((e) => e.trackName).toList();
  }

//PlayList linking methods.
  Future<void> addTrackToFavorites(String trackName) async {
    // // Get the track id from the Tracks table
    // var track = await _db
    //     .query('Tracks', where: 'trackName = ?', whereArgs: [trackName]);

    // // Get the 'favorites' playlist id from the Playlists table
    // var playlist = await _db.query('Playlists',
    //     where: 'playlistName = ?', whereArgs: ['favorites']);

    // int trackId = track[0]['id'] as int;
    // int playlistId = playlist[0]['id'] as int;

    // // Check if the track is already in the 'favorites' playlist
    // if (!await _isTrackInPlaylist(trackId, playlistId)) {
    //   // If not, insert the track into the 'favorites' playlist
    //   await _db.insert(
    //       'Playlist_Tracks', {"playlistId": playlistId, "trackId": trackId});
    // }
    await addTrackToPlayList(trackName, 'favorites');
    log('added to favorites');
  }

  Future<void> removeFromFavorite(String trackName) async {
    await removeTrackFromPlaylist(trackName, 'favorites');
    log('removed from fav');
  }

  Future<void> addTrackToPlayList(String trackName, String playListName) async {
    var track = await _db
        .query('Tracks', where: 'trackName = ?', whereArgs: [trackName]);
    var playlist = await _db.query('Playlists',
        where: 'playlistName = ?', whereArgs: [playListName]);

    int trackId = track[0]['id'] as int;
    int playlistId = playlist[0]['id'] as int;

    if (!await _isTrackInPlaylist(trackId, playlistId)) {
      await _db.insert(
          'Playlist_Tracks', {"playlistId": playlistId, "trackId": trackId});
    }
  }

  Future<void> removeTrackFromPlaylist(
      String trackName, String playListName) async {
    var track = await _db
        .query('Tracks', where: 'trackName = ?', whereArgs: [trackName]);
    var playlist = await _db.query('Playlists',
        where: 'playlistName = ?', whereArgs: [playListName]);

    int trackId = track[0]['id'] as int;
    int playlistId = playlist[0]['id'] as int;

    if (await _isTrackInPlaylist(trackId, playlistId)) {
      await _db.delete('Playlist_Tracks',
          where: 'playlistId = ? AND trackId = ?',
          whereArgs: [playlistId, trackId]);
    }
  }

  Future<bool> _isTrackInPlaylist(int trackId, int playlistId) async {
    var result = await _db.query('Playlist_Tracks',
        where: 'playlistId = ? AND trackId = ?',
        whereArgs: [playlistId, trackId]);
    return result.isNotEmpty;
  }

  Future<List<String>> getPlaylistsForTrack(String trackName) async {
    log('Get the track id from the Tracks table');
    var trackId = await _db
        .query('Tracks', where: 'trackName = ?', whereArgs: [trackName]);

    // Query the Playlist_Tracks table for all playlists that contain the track
    var playlistIds = await _db.rawQuery(
        'SELECT * FROM Playlist_Tracks WHERE trackId = ?', [trackId[0]['id']]);

    // Get the playlist names from the Playlists table
    List<String> playlistNames = [];
    for (var playlist in playlistIds) {
      var playlistName = await _db.query('Playlists',
          where: 'id = ?', whereArgs: [playlist['playlistId']]);
      playlistNames.add(playlistName[0]['playlistName'] as String);
    }
    print(playlistNames);
    return playlistNames;
  }

  Future<void> deleteTrackFromPlayList(
    String trackName,
    String playListName,
  ) async {
    var trackId = await _db
        .query('Tracks', where: 'trackName = ?', whereArgs: [trackName]);
    var playlistId = await _db.query('Playlists',
        where: 'playlistName = ?', whereArgs: [playListName]);
    await _db.delete('Playlist_Tracks',
        where: 'playlistId = ? AND trackId = ?',
        whereArgs: [playlistId[0]['id'], trackId[0]['id']]);
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
