import 'dart:developer';
import 'dart:io';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/utils/waveform_extension.dart';
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
  AudioBloc()
      : super(AudioInitial(
          controller: null,
          currentIndex: 0,
          tracks: [],
          progressStream: BehaviorSubject<WaveformProgress>(),
        )) {
    on<AudioInitEvent>((event, emit) async {
      if (state.controller == null) {
        await _onControllerNull(emit, event);
      } else if (_isCurrentlyPlayingAndSelectedNotSame(event)) {
        //if the current audio is different from selected audio.
        add(ChangeMusicEvent(event.width, event.tracks, event.index));
      }
      _listenToControllerAndEmitLoadedState(emit, event);

      if (_isWaveFormAlreadyGeneratedForThisAudio(event)) {
        _updateTotalDuration(event);
      } else {
        //will update total duration on progress stream completion.
        _generateWaveForm(
          event.tracks[event.index],
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
          tracks: state.tracks,
          progressStream: state.progressStream,
        ),
      );
    });
    on<AudioPlayerStateChangedEvent>((event, emit) {
      if (event.playerState == PlayerState.playing) {
        emit(_audioPlayerState(isPlaying: true));
      } else if (event.playerState == PlayerState.completed) {
        add(ChangeMusicEvent(
          event.width,
          state.tracks,
          //if the index exceed the length start from beggning.
          state.currentIndex + 1 < state.tracks.length
              ? state.currentIndex + 1
              : 0,
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
        event.width,
        event.index,
      ));
    });
  }

  AudioPositionChangedState _updatedAudioPositionState(
    Duration currentDuration,
  ) {
    return AudioPositionChangedState(
      currentDuration: currentDuration,
      controller: state.controller,
      totalDuration: state.totalDuration,
      currentIndex: state.currentIndex,
      tracks: state.tracks,
      progressStream: state.progressStream,
    );
  }

  TotalDurationState _updateTotalDuratonState(Duration totalDuration) {
    return TotalDurationState(
      controller: state.controller,
      currentDuration: state.currentDuration,
      totalDuration: totalDuration,
      currentIndex: state.currentIndex,
      tracks: state.tracks,
      progressStream: state.progressStream,
    );
  }

  AudioPlayerStateChangedState _audioPlayerState({required bool isPlaying}) {
    return AudioPlayerStateChangedState(
      isPlaying: isPlaying,
      currentDuration: state.currentDuration,
      controller: state.controller,
      totalDuration: state.totalDuration,
      currentIndex: state.currentIndex,
      tracks: state.tracks,
      progressStream: state.progressStream,
    );
  }

  void _listenToControllerAndEmitLoadedState(
      Emitter<AudioState> emit, AudioInitEvent event) {
    emit(AudioLoadedState(
      controller: state.controller,
      currentDuration: state.currentDuration,
      totalDuration: state.totalDuration,
      currentIndex: state.currentIndex,
      tracks: event.tracks,
      progressStream: state.progressStream,
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
      add(TotalDurationEvent(
          event.tracks[event.index].waveformWrapper!.waveform.duration));
    }
  }

  bool _isWaveFormAlreadyGeneratedForThisAudio(AudioInitEvent event) =>
      event.tracks[event.index].waveformWrapper != null;

  bool _isCurrentlyPlayingAndSelectedNotSame(AudioInitEvent event) {
    return state.tracks[state.currentIndex].trackName !=
        event.tracks[event.index].trackName;
  }

  ///emit [AudioInitial] and set&play audio controller.
  Future<void> _onControllerNull(
      Emitter<AudioState> emit, AudioInitEvent event) async {
    emit(AudioInitial(
      controller: AudioPlayer(),
      currentIndex: event.index,
      tracks: event.tracks,
      progressStream: BehaviorSubject<WaveformProgress>(),
    ));
    log(event.tracks[event.index].trackName);
    await state.controller!
        .play(DeviceFileSource(event.tracks[event.index].trackName));
  }
}

void _generateWaveForm(
  Track track,
  BehaviorSubject<WaveformProgress> progressStream,
) async {
  final audioFile = File(track.trackUrl);
  try {
    final waveFile = File(
        join((await getTemporaryDirectory()).path, '${track.trackName}.wave'));

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
        );
      }
    }, onError: progressStream.addError);
  } catch (e) {
    progressStream.addError(e);
  }
}
