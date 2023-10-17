import 'dart:io';

import 'package:audio_player/database/database_service.dart';
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
part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final HomeBloc homeBloc;

  AudioBloc(this.homeBloc) : super(AudioState.initial()) {
    on<AudioInitEvent>((event, emit) async {
      if (state.controller == null) {
        emit(state.copyWith(
          changeType: ChangeType.initial,
          controller: AudioPlayer(),
          currentIndex: event.currentIndex,
          progressStream: BehaviorSubject<WaveformProgress>(),
          tracks: event.tracks,
          isPlaying: true,
        ));
        await state.controller!.play(DeviceFileSource(
            state.tracks.elementAt(state.currentIndex).trackUrl));
      } else if (_isCurrentlyPlayingAndSelectedNotSame(event)) {
        //if the current audio is different from selected audio.
        add(ChangeMusicEvent(event.tracks, event.currentIndex, event.width));
      }
      _listenToControllers(event);

      _generateWaveFormIfNeeded(event);
    });

    on<AudioEndEvent>((event, emit) {
      if (state.controller != null) state.controller!.dispose();
      emit(state.end());
    });

    on<AudioPlayerStateChangedEvent>((event, emit) {
      if (event.playerState == PlayerState.playing) {
        emit(state.copyWith(
          changeType: ChangeType.playerState,
          isPlaying: true,
        ));
      } else if (event.playerState == PlayerState.completed) {
        add(ChangeMusicEvent.next(state, event.width));
      } else {
        emit(state.copyWith(
            changeType: ChangeType.playerState, isPlaying: false));
      }
    });

    on<AudioPositionChangedEvent>((event, emit) {
      emit(state.copyWith(
        changeType: ChangeType.currentDuration,
        currentDuration: event.currentDuration,
        isPlaying: true,
      ));
    });

    on<SwitchPlayerStateEvent>((event, emit) {
      if (state.controller != null) {
        state.isPlaying
            ? state.controller!.pause()
            : state.controller!.resume();
      }
    });

    on<TotalDurationEvent>((event, emit) {
      emit(state.copyWith(
          changeType: ChangeType.totalDuration,
          totalDuration: event.totalDuration));
    });

    on<ChangeMusicEvent>((event, emit) {
      add(AudioEndEvent());
      add(AudioInitEvent(
        event.tracks,
        event.currentIndex,
        event.width,
      ));
    });

    on<AddTrackToFavorites>((event, emit) {
      DataBaseService().addTrackToFavorites(
          state.tracks.elementAt(state.currentIndex).trackName);
    });

    on<RemoveTrackFromFavorites>((event, emit) {});

    on<PlayListPlayerStateSwitch>((event, emit) {
      //when click on the playlist play/pause button.
      if (state.tracks == event.tracks) {
        //if currently playing tracks are same, just toggle the player state.
        add(SwitchPlayerStateEvent());
      } else {
        add(AudioInitEvent(event.tracks, 0, event.width));
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

      JustWaveform.extract(
        audioInFile: audioFile,
        waveOutFile: waveFile,
      ).listen((data) {
        progressStream.add(data);
        if (data.waveform != null) {
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
              //updating the tracklist, if not waveform warapper
              //will be still null for this track in home state.
              homeBloc.add(RenderTracksFromApp());
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
    state.controller!.onPositionChanged.listen((Duration p) {
      add(AudioPositionChangedEvent(p));
    });

    state.controller!.onPlayerStateChanged.listen((PlayerState s) {
      add(AudioPlayerStateChangedEvent(s, event.width));
    });
  }

  bool _isCurrentlyPlayingAndSelectedNotSame(AudioInitEvent event) {
    return (state.tracks.elementAt(state.currentIndex).trackName) !=
        event.tracks.elementAt(event.currentIndex).trackName;
  }
}
