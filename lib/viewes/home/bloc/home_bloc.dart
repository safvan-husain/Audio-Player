import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<RenderMusicHomeEvent>((event, emit) async {
      List<AudioModel> musics = await DataBaseService().getAllMusic();
      emit(HomeLoaded(audioList: musics));
    });
  }
}
