import 'dart:convert';
import 'dart:developer';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const platform = MethodChannel('example.com/channel');
  HomeBloc() : super(HomeInitial()) {
    var databaseServices = DataBaseService();
    on<RenderTracksFromDevice>((event, emit) async {
      add(RenderTracksFromApp());
      List<Track> tracks = [];
      late String jsonListTracks;
      if (await ensurePermissionGranted()) {
        try {
          jsonListTracks = await platform.invokeMethod('getRandomNumber');
        } on PlatformException catch (e) {
          print(e);
          jsonListTracks = '';
        }
        List trackList = jsonDecode(jsonListTracks);
        if (trackList.isNotEmpty) {
          for (var element in trackList) {
            tracks.add(Track.fromMap(element));
          }
        }
      } else {
        throw ('Permission denied');
      }
      for (var track in tracks) {
        await databaseServices.insertTrack(track);
      }
      add(RenderTracksFromApp());
    });
    on<RenderTracksFromApp>((event, emit) async {
      List<Track> tracks = await databaseServices.getAllTracks();
      List<String> favTrackNames = await databaseServices.getAllFavorites();
      emit(HomeLoaded(trackList: setFavoriteForTracks(tracks, favTrackNames)));
    });
    on<RenderPlayList>((event, emit) async {
      List<String> favTrackNames = await databaseServices.getAllFavorites();
      List<Track> tracks =
          await databaseServices.getTracksFromPlayList(event.playListName);
      emit(HomeLoaded(
        trackList: setFavoriteForTracks(tracks, favTrackNames),
        playList: event.playListName,
      ));
    });
    on<Favorite>((event, emit) async {
      List<String> favTrackNames = await databaseServices.getAllFavorites();
      if (event.isFavorite) {
        databaseServices.addTrackToFavorites(event.trackName);
        favTrackNames.add(event.trackName);
      } else {
        databaseServices.removeFromFavorite(event.trackName);
        favTrackNames.remove(event.trackName);
      }
      if (state.playList == "favorites") {
        emit(HomeLoaded(
          trackList: favoriteTracks(state.trackList, favTrackNames),
          playList: state.playList,
        ));
      } else {
        emit(HomeLoaded(
          trackList: setFavoriteForTracks(state.trackList, favTrackNames),
          playList: state.playList,
        ));
      }
    });
  }
}

///returns only [tracks] that marked favorite from [favoriteTrackNames].
List<Track> favoriteTracks(
  List<Track> tracks,
  List<String> favoriteTrackNames,
) {
  return tracks
      .where((element) => favoriteTrackNames.contains(element.trackName))
      .toList();
}

///mark favorite for [tracks] that are in [favoriteTrackNames].
List<Track> setFavoriteForTracks(
  List<Track> tracks,
  List<String> favoriteTrackNames,
) {
  for (Track track in tracks) {
    if (favoriteTrackNames.contains(track.trackName)) {
      track.isFavorite = true;
    } else {
      track.isFavorite = false;
    }
  }
  return tracks;
}

Future<bool> ensurePermissionGranted() async {
  PermissionStatus status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}
