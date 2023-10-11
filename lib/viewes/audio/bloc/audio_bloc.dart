import 'dart:developer';
import 'dart:io';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/utils/waveform_extension.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final HomeBloc homeBloc;
  AudioBloc(this.homeBloc)
      : super(AudioInitial(
          controller: null,
          currentIndex: 0,
          progressStream: BehaviorSubject<WaveformProgress>(),
          tracks: [],
        )) {
    on<AudioInitEvent>((event, emit) async {
      if (state.controller == null) {
        event.onNavigate();
        await _onControllerNull(emit, event);
      } else if (_isCurrentlyPlayingAndSelectedNotSame(event)) {
        //if the current audio is different from selected audio.
        add(ChangeMusicEvent(event.tracks, event.currentIndex, event.width));
      }
      _listenToControllerAndEmitLoadedState(emit, event);

      if (_isWaveFormAlreadyGeneratedForThisAudio(event)) {
        _updateTotalDuration(event);
      } else {
        //will update total duration on progress stream completion.
        _generateWaveForm(
          event.tracks.elementAt(event.currentIndex),
          state.progressStream,
        );
      }
    });

    on<AudioEndEvent>((event, emit) {
      if (state.controller != null) state.controller!.dispose();
      emit(
        AudioEndState(
          controller: null,
          currentDuration: Duration.zero,
          totalDuration: Duration.zero,
          currentIndex: state.currentIndex,
          progressStream: state.progressStream,
          tracks: state.tracks,
        ),
      );
    });

    on<AudioPlayerStateChangedEvent>((event, emit) {
      if (event.playerState == PlayerState.playing) {
        emit(_audioPlayerState(isPlaying: true));
      } else if (event.playerState == PlayerState.completed) {
        add(ChangeMusicEvent(
          state.tracks,
          state.currentIndex > state.tracks.length - 1
              ? 0
              : state.currentIndex + 2,
          event.width, //need attention.
          //if the index exceed the length start from beggning.
          //need to change
        ));
      } else {
        emit(_audioPlayerState(isPlaying: false));
      }
    });

    on<AudioPositionChangedEvent>((event, emit) {
      emit(_updatedAudioPositionState(event.currentDuration));
    });

    on<SwitchPlayerStateEvent>((event, emit) {
      if (state.controller != null) {
        if (state.isPlaying) {
          state.controller!.pause();
        } else {
          state.controller!.resume();
        }
      }
    });

    on<TotalDurationEvent>((event, emit) {
      emit(_updateTotalDuratonState(event.totalDuration));
    });

    on<ChangeMusicEvent>((event, emit) {
      add(AudioEndEvent());
      add(AudioInitEvent(
        event.tracks,
        event.currentIndex,
        event.width,
        () {},
      ));
    });
    on<AddTrackToFavorites>((event, emit) {
      DataBaseService().addTrackToFavorites(
          state.tracks.elementAt(state.currentIndex).trackName);
    });
    on<RemoveTrackFromFavorites>((event, emit) {});
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
            ),
            () {
              homeBloc.add(RenderTracksFromApp());
            },
          );
        }
      }, onError: progressStream.addError);
    } catch (e) {
      progressStream.addError(e);
    }
  }

  AudioPositionChangedState _updatedAudioPositionState(
    Duration currentDuration,
  ) {
    return AudioPositionChangedState(
      currentDuration: currentDuration,
      controller: state.controller,
      totalDuration: state.totalDuration,
      currentIndex: state.currentIndex,
      progressStream: state.progressStream,
      tracks: state.tracks,
    );
  }

  TotalDurationState _updateTotalDuratonState(Duration totalDuration) {
    return TotalDurationState(
      controller: state.controller,
      currentDuration: state.currentDuration,
      totalDuration: totalDuration,
      currentIndex: state.currentIndex,
      progressStream: state.progressStream,
      tracks: state.tracks,
    );
  }

  AudioPlayerStateChangedState _audioPlayerState({required bool isPlaying}) {
    return AudioPlayerStateChangedState(
      isPlaying: isPlaying,
      currentDuration: state.currentDuration,
      controller: state.controller,
      totalDuration: state.totalDuration,
      currentIndex: state.currentIndex,
      progressStream: state.progressStream,
      tracks: state.tracks,
    );
  }

  void _listenToControllerAndEmitLoadedState(
      Emitter<AudioState> emit, AudioInitEvent event) {
    emit(AudioLoadedState(
      controller: state.controller,
      currentDuration: state.currentDuration,
      totalDuration: state.totalDuration,
      currentIndex: state.currentIndex,
      progressStream: state.progressStream,
      tracks: state.tracks,
    ));
    state.controller!.onPositionChanged.listen((Duration p) {
      add(AudioPositionChangedEvent(p));
    });
    state.controller!.onDurationChanged.listen((Duration d) {
      if (state.totalDuration == Duration.zero) {
        add(TotalDurationEvent(d));
      }
    });
    state.controller!.onPlayerStateChanged.listen((PlayerState s) {
      add(AudioPlayerStateChangedEvent(s, event.width));
    });
  }

  void _updateTotalDuration(AudioInitEvent event) {
    if (state.totalDuration == Duration.zero) {
      add(TotalDurationEvent(event.tracks
          .elementAt(event.currentIndex)
          .waveformWrapper!
          .waveform
          .duration));
    }
  }

  bool _isWaveFormAlreadyGeneratedForThisAudio(AudioInitEvent event) =>
      event.tracks.elementAt(state.currentIndex).waveformWrapper != null;

  bool _isCurrentlyPlayingAndSelectedNotSame(AudioInitEvent event) {
    return (state.tracks.elementAt(state.currentIndex).trackName) !=
        event.tracks.elementAt(event.currentIndex).trackName;
  }

  ///emit [AudioInitial] and set&play audio controller.
  Future<void> _onControllerNull(
      Emitter<AudioState> emit, AudioInitEvent event) async {
    emit(AudioInitial(
      controller: AudioPlayer(),
      currentIndex: event.currentIndex,
      progressStream: BehaviorSubject<WaveformProgress>(),
      tracks: event.tracks,
    ));
    log('current ${state.currentIndex}, length: ${state.tracks.length}');
    await state.controller!.play(
        DeviceFileSource(state.tracks.elementAt(state.currentIndex).trackUrl));
  }
}
