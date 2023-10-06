import 'dart:convert';

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
        await DataBaseService().insertTrack(track);
      }
      add(RenderTracksFromApp());
    });
    on<RenderTracksFromApp>((event, emit) async {
      List<Track> tracks = await DataBaseService().getAllTracks();
      emit(HomeLoaded(trackList: tracks));
    });
  }
}

Future<bool> ensurePermissionGranted() async {
  PermissionStatus status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}
