import 'dart:developer';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  final HomeBloc homeBloc;
  DrawerBloc(this.homeBloc) : super(const DrawerInitial()) {
    var databaseServices = DataBaseService();
    on<SwitchPlayListExtendedness>(
      (event, emit) {
        emit(DrawerStateChange(
          playLists: state.playLists,
          isPlayListExtended: !state.isPlayListExtended,
        ));
      },
    );
    on<ListPlayLists>(
      (event, emit) async {
        log('list play lists');
        List<String> playLists = await databaseServices.getAllPlayListName();
        print(playLists);
        emit(DrawerStateChange(
          playLists: playLists,
          isPlayListExtended: !state.isPlayListExtended,
        ));
      },
    );
  }
}
