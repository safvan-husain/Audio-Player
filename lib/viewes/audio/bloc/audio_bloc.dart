import 'dart:developer';
import 'dart:io';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/audio_player_services.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/waveform_extension.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final HomeBloc homeBloc;
  final AudioPlayerHandler audioHanfler;

  AudioBloc(this.homeBloc, this.audioHanfler)
      : super(AudioState.initial(audioHanfler)) {
    on<AudioInitEvent>((event, emit) async {
      if (_isCurrentlyPlayingAndSelectedNotSame(event) ||
          state.isPlaying == PlayerState.stopped) {
        log('before event: ${event.tracks.length}');
        emit(state.copyWith(
          changeType: ChangeType.initial,
          currentIndex: event.currentIndex,
          progressStream: BehaviorSubject<WaveformProgress>(),
          tracks: event.tracks,
          isPlaying: PlayerState.playing,
        ));
        log('state : ${state.tracks.length} : ${state.currentIndex} : event : ${event.tracks.length} :${event.currentIndex} ');
        await state.audioHandler.setNewFile(
          state.tracks.elementAt(state.currentIndex),
          onNext: () async {
            log('on next: ${state.tracks.length}');
            add(ChangeMusicEvent.next(state, event.width));
          },
          onPrevious: () {
            add(ChangeMusicEvent.previous(state, event.width));
          },
          onStop: () async {
            emit(state.end());
          },
        );
      }
      _listenToControllers(event);
      _generateWaveFormIfNeeded(event);
    });

    on<AudioEndEvent>((event, emit) {
      state.audioHandler.stop();
      emit(AudioState.initial(audioHanfler));
    });

    on<ChangeMusicEvent>((event, emit) async {
      log('change music event');
      // add(AudioEndEvent());
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
      if (state.isPlaying == PlayerState.playing) {
        state.audioHandler.pause();
      } else if (state.isPlaying == PlayerState.stopped) {
        log('stopped in switch');
        add(AudioInitEvent(state.tracks, state.currentIndex, event.width));
      } else {
        log(state.tracks.length.toString());
        state.audioHandler.play();
      }
    });

    on<TotalDurationEvent>((event, emit) {
      emit(state.copyWith(
          changeType: ChangeType.totalDuration,
          totalDuration: event.totalDuration));
    });

    on<AddTrackToFavorites>((event, emit) {
      DataBaseService().addTrackToFavorites(
          state.tracks.elementAt(state.currentIndex).trackName);
    });

    on<RemoveTrackFromFavorites>((event, emit) {});

    on<PlayListPlayerStateSwitch>((event, emit) {
      //when click on the playlist play/pause button.
      if (event.tracks.isNotEmpty) {
        if (state.tracks == event.tracks) {
          //if currently playing tracks are same, just toggle the player state.
          add(SwitchPlayerStateEvent(event.width));
        } else {
          log('audio init event from playlist player state switch');
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

  void _generateWaveForm(
    Track track,
    BehaviorSubject<WaveformProgress> progressStream,
  ) async {
    final audioFile = File(track.trackUrl);
    try {
      final waveFile = File(join(
          (await getTemporaryDirectory()).path, '${track.trackName}.wave'));

      JustWaveform.extract(audioInFile: audioFile, waveOutFile: waveFile)
          .listen((data) {
        progressStream.add(data);
        if (data.waveform != null) {
          //adding wave form for the track object.
          state.tracks.elementAt(state.currentIndex).waveformWrapper =
              WaveformWrapper(data.waveform!);
          DataBaseService().storeWaveForm(
            Track(
              trackName: track.trackName,
              trackDetail: track.trackDetail,
              trackUrl: track.trackUrl,
              waveformWrapper: WaveformWrapper(data.waveform!),
              trackDuration: track.trackDuration,
              coverImage: track.coverImage,
            ),
            () {
              //updating the tracklist on Home, if not, waveform warapper
              //will be still null for this track in home state.
              if (homeBloc.state.onHome) {
                homeBloc.add(RenderTracksFromApp());
              } else {
                homeBloc.add(RenderPlayList(homeBloc.state.playLists[0]));
              }
            },
          );
        }
      }, onError: progressStream.addError);
    } catch (e) {
      progressStream.addError(e);
    }
  }

  ///generate waveform if not exist.
  void _generateWaveFormIfNeeded(AudioInitEvent event) {
    if (event.tracks.elementAt(event.currentIndex).waveformWrapper == null) {
      _generateWaveForm(
        event.tracks.elementAt(event.currentIndex),
        state.progressStream,
      );
    }
  }

  void _listenToControllers(AudioInitEvent event) {
    state.audioHandler.player.onPositionChanged.listen((Duration p) {
      // print(p);
      add(AudioPositionChangedEvent(p));
    });

    state.audioHandler.player.onPlayerStateChanged.listen((PlayerState s) {
      print(s);
      add(AudioPlayerStateChangedEvent(s, event.width));
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
