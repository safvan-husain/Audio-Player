import 'dart:developer';

import 'package:audio_player/database/data_base.dart';
import 'package:audio_player/model/track_model.dart';
import 'package:sqflite/sqflite.dart';

mixin PlayListDataBase {
  final Database _db = MyDataBase().db; //Play List Methods.
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
        // Track(
        //   trackDetail: "Safvan",
        //   trackName: "Safvan's Speech",
        //   trackUrl: '/',
        // )
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

  Future<bool> _isTrackInPlaylist(int trackId, int playlistId) async {
    var result = await _db.query('Playlist_Tracks',
        where: 'playlistId = ? AND trackId = ?',
        whereArgs: [playlistId, trackId]);
    return result.isNotEmpty;
  }
}
