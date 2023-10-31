import 'dart:convert';
import 'dart:io';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/common/track_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const platform = MethodChannel("example.com/channel");
  HomeBloc() : super(HomeInitial()) {
    var databaseServices = DataBaseService();
    on<RenderTracksFromDevice>((event, emit) async {
      add(RenderTracksFromApp());
      List<Track> tracks = [];
      late String jsonListTracks;
      if (await _ensurePermissionGranted()) {
        try {
          //extracting all the tracks from internal and external storage
          //using android mediastore.
          jsonListTracks = await platform.invokeMethod("getRandomNumber");
        } on PlatformException {
          jsonListTracks = '[]';
        }
        List trackList = jsonDecode(jsonListTracks);

        for (var element in trackList) {
          Uint8List coverImage =
              await _extractTrackCoverImage(element['trackUrl']) ??
                  await _placeDefaultImage();
          tracks.add(Track.fromLocal(element, coverImage));
        }
      } else {
        //show message that permission would need.
        throw ('Permission denied');
      }
      for (var track in tracks) {
        await databaseServices.insertTrack(track);
      }
      await databaseServices.deleteNonExistentTracks(tracks);
      add(RenderTracksFromApp());
    });

    on<RenderTracksFromApp>((event, emit) async {
      //used to render tracks from app storage.
      List<Track> tracks = await databaseServices.getAllTracks();
      add(ListPlayLists());
      List<String> favTrackNames = await databaseServices.getAllFavorites();
      emit(HomeLoaded(
        trackList: setFavoriteForTracks(tracks, favTrackNames),
        playLists: state.playLists,
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
      if (state.playLists.length == 1 &&
          state.playLists[0] == "favorites" &&
          !state.onHome) {
        emit(state.copyWith(
          tracks: favoriteTracksOnly(state.trackList, favTrackNames),
          playLists: state.playLists,
        ));
      } else {
        emit(state.copyWith(
          tracks: setFavoriteForTracks(state.trackList, favTrackNames),
          playLists: state.playLists,
        ));
      }
    });
    on<ListPlayLists>(
      (event, emit) async {
        List<String> playLists = await databaseServices.getAllPlayListName();

        emit(PlayListLoaded(trackList: state.trackList, playLists: playLists));
      },
    );
    on<RenderPlayList>(
      (event, emit) async {
        List<String> favTrackNames = await databaseServices.getAllFavorites();
        List<Track> tracks =
            await databaseServices.getTracksFromPlayList(event.playListName);
        emit(PlayListRendered(
            trackList: setFavoriteForTracks(tracks, favTrackNames),
            playLists: [event.playListName]));
      },
    );
  }
}

///returns only [tracks] that marked favorite from [favoriteTrackNames].
List<Track> favoriteTracksOnly(
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

Future<bool> _ensurePermissionGranted() async {
  PermissionStatus status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}

Future<Uint8List> _placeDefaultImage() async {
  final ByteData bytes = await rootBundle.load('assets/images/track.webp');
  final Uint8List list = bytes.buffer.asUint8List();
  return list;
}

Future<Uint8List?> _extractTrackCoverImage(String trackUrl) async {
  final metadata = await MetadataRetriever.fromFile(
    File(trackUrl),
  );
  return metadata.albumArt;
}
