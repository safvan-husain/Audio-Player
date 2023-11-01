
import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/audio_player_services.dart';
import 'package:audio_player/common/track_model.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final HomeBloc homeBloc;
  final AudioPlayerHandler audioHanfler;

  AudioBloc(this.homeBloc, this.audioHanfler)
      : super(AudioState.initial(audioHanfler)) {
    on<AudioInitEvent>((event, emit) async {
      if (_isCurrentlyPlayingAndSelectedNotSame(event) ||
          state.playerState == PlayerState.stopped) {
        //preventing playing from the start if it is the same audio file.
        emit(state.copyWith(
          changeType: ChangeType.initial,
          currentIndex: event.currentIndex,
          progressStream: BehaviorSubject<WaveformProgress>(),
          tracks: _updateWaveGeneratedTracks(
              audioTracks: event.tracks, homeTracks: homeBloc.state.trackList),
          isPlaying: PlayerState.playing,
        ));
        //audio handler handle both in app controll and from notification panel.
        await state.audioHandler.setNewFile(
          state.tracks.elementAt(state.currentIndex),
          onNext: () => add(ChangeMusicEvent.next(state, event.width)),
          onPrevious: () => add(ChangeMusicEvent.previous(state, event.width)),
        );
      }
      state.audioHandler.player.onPositionChanged.listen((Duration p) {
        add(AudioPositionChangedEvent(p));
      });

      state.audioHandler.player.onPlayerStateChanged.listen((PlayerState s) {
        add(AudioPlayerStateChangedEvent(s, event.width));
      });
    });

    on<AudioEndEvent>((event, emit) {
      state.audioHandler.stop();
      emit(AudioState.initial(audioHanfler));
    });

    on<ChangeMusicEvent>((event, emit) async {
      add(AudioInitEvent(
        event.tracks,
        event.currentIndex,
        event.width,
      ));
    });

    on<AudioPlayerStateChangedEvent>((event, emit) {
      emit(state.copyWith(
        changeType: ChangeType.playerState,
        isPlaying: event.playerState,
      ));
      if (event.playerState == PlayerState.completed) {
        add(ChangeMusicEvent.next(state, event.width));
      }
    });

    on<AudioPositionChangedEvent>((event, emit) {
      emit(state.copyWith(
        changeType: ChangeType.currentDuration,
        currentDuration: event.currentDuration,
      ));
    });

    on<SwitchPlayerStateEvent>((event, emit) {
      if (state.playerState == PlayerState.playing) {
        state.audioHandler.pause();
      } else if (state.playerState == PlayerState.stopped) {
        add(AudioInitEvent(state.tracks, state.currentIndex, event.width));
      } else {
        state.audioHandler.play();
      }
    });

    on<TotalDurationEvent>((event, emit) {
      emit(state.copyWith(
        changeType: ChangeType.totalDuration,
        totalDuration: event.totalDuration,
      ));
    });

    on<AddTrackToFavorites>((event, emit) {
      DataBaseService().addTrackToFavorites(
          state.tracks.elementAt(state.currentIndex).trackName);
    });

    on<PlayListPlayerStateSwitch>((event, emit) {
      //when click on the playlist play/pause button.
      if (event.tracks.isNotEmpty) {
        if (state.tracks == event.tracks) {
          //if currently playing tracks are same, just toggle the player state.
          add(SwitchPlayerStateEvent(event.width));
        } else {
          add(AudioInitEvent(event.tracks, 0, event.width));
        }
      }
    });

    on<SwitchShuffle>((event, emit) {
      emit(state.copyWith(
        changeType: ChangeType.shuffle,
        isShuffling: !state.isShuffling,
      ));
    });
  }

  bool _isCurrentlyPlayingAndSelectedNotSame(AudioInitEvent event) {
    if (state.tracks.isEmpty) return true;
    //return true if currently playing and selected is not same
    //or selected playlist and current playlist is not same.
    return (state.tracks.elementAt(state.currentIndex).trackName) !=
            event.tracks.elementAt(event.currentIndex).trackName ||
        state.tracks != event.tracks;
  }
}

//update wave genereated tracks from homstate to audiostate.
List<Track> _updateWaveGeneratedTracks(
    {required List<Track> audioTracks, required List<Track> homeTracks}) {
  List<Track> tracks = [];

  for (Track audioTrack in audioTracks) {
    if (audioTrack.waveformWrapper == null) {
      bool isTrackFound = false;
      for (Track homeTrack in homeTracks) {
        if (homeTrack.trackName == audioTrack.trackName &&
            homeTrack.waveformWrapper != null) {
          tracks.add(homeTrack);
          isTrackFound = true;
          break;
        }
      }
      if (!isTrackFound) {
        tracks.add(audioTrack);
      }
    } else {
      tracks.add(audioTrack);
    }
  }

  return tracks;
  // return audioTracks;
}
