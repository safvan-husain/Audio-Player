import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/waveform_extension.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
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
        // event.onNavigate();
        await _setnewTrackListAndPlayCurrent(emit, event);
      } else if (_isCurrentlyPlayingAndSelectedNotSame(event)) {
        //if the current audio is different from selected audio.
        add(ChangeMusicEvent(event.tracks, event.currentIndex, event.width));
      }
      _listenToControllerAndEmitLoadedState(emit, event);

      if (_isWaveFormAlreadyGeneratedForThisAudio(event)) {
        _updateTotalDuration(event.tracks
            .elementAt(event.currentIndex)
            .waveformWrapper!
            .waveform
            .duration);
      } else {
        Duration? dur = await extractTrackDuration(
            event.tracks.elementAt(event.currentIndex).trackUrl);
        if (dur != null) {
          _updateTotalDuration(dur);
        }

        //will update total duration on progress stream completion.
        _generateWaveForm(
          event.tracks.elementAt(event.currentIndex),
          state.progressStream,
        );
      }
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
        add(
          ChangeMusicEvent(
            state.tracks,
            state.isShuffling
                //pick random if shuffle is true.
                ? Random().nextInt(state.tracks.length)
                //if the index exceed the length start from beggning.
                : state.currentIndex > state.tracks.length - 2
                    ? 0
                    : state.currentIndex + 1,
            event.width,
          ),
        );
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
      dev.log('play list player state');
      if (state.tracks == event.tracks) {
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

  Future<Duration?> extractTrackDuration(String trackUrl) async {
    final metadata = await MetadataRetriever.fromFile(
      File(trackUrl),
    );
    if (metadata.trackDuration != null) {
      return Duration(milliseconds: metadata.trackDuration!);
    }
    return null;
  }

//refactor.
  void _listenToControllerAndEmitLoadedState(
      Emitter<AudioState> emit, AudioInitEvent event) {
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

  void _updateTotalDuration(Duration duration) {
    if (state.totalDuration == Duration.zero) {
      add(TotalDurationEvent(duration));
    }
  }

  bool _isWaveFormAlreadyGeneratedForThisAudio(AudioInitEvent event) =>
      event.tracks.elementAt(event.currentIndex).waveformWrapper != null;

  bool _isCurrentlyPlayingAndSelectedNotSame(AudioInitEvent event) {
    return (state.tracks.elementAt(state.currentIndex).trackName) !=
        event.tracks.elementAt(event.currentIndex).trackName;
  }

  ///emit [AudioInitial] and set&play audio controller.
  Future<void> _setnewTrackListAndPlayCurrent(
      Emitter<AudioState> emit, AudioInitEvent event) async {
    dev.log('_setnewTrackListAndPlayCurrent called');
    emit(state.copyWith(
      changeType: ChangeType.initial,
      controller: AudioPlayer(),
      currentIndex: event.currentIndex,
      progressStream: BehaviorSubject<WaveformProgress>(),
      tracks: event.tracks,
      isPlaying: true,
    ));
    await state.controller!.play(
        DeviceFileSource(state.tracks.elementAt(state.currentIndex).trackUrl));
  }
}
