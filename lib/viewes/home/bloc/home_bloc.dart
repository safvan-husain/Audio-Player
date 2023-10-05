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
      List<Track> tracks = await DataBaseService().getAllTracks();
      emit(HomeLoaded(trackList: tracks));
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
