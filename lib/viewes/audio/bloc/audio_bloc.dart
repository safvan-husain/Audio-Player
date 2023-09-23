import 'dart:developer';
import 'dart:io';

import 'package:audio_player/database/database_service.dart';
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

//see a worckaround without making audioplayer null.
class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc()
      : super(AudioInitial(
          controller: AudioPlayer(),
          currentIndex: 0,
          audios: [],
          progressStream: BehaviorSubject<WaveformProgress>(),
        )) {
    on<AudioInitEvent>((event, emit) async {
      log('${event.audios.length} : ${event.index}');

      if (state.controller == null) {
        emit(AudioInitial(
          controller: AudioPlayer(),
          currentIndex: event.index,
          audios: event.audios,
          progressStream: BehaviorSubject<WaveformProgress>(),
        ));
      }

      await state.controller!
          .play(DeviceFileSource(event.audios[event.index].audioPath));
      emit(AudioLoadedState(
        controller: state.controller,
        currentDuration: state.currentDuration,
        totalDuration: state.totalDuration,
        currentIndex: state.currentIndex,
        audios: event.audios,
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
        add(AudioPlayerStateChangedEvent(s));
      });

      log('${state.audios.length} : ${state.currentIndex}');
      if (event.audios[event.index].waveformWrapper == null) {
        log('wave is null');
        _init(event.audios[event.index].audioPath, state.progressStream);
      } else {
        log('wave is not null');
        if (state.totalDuration == Duration.zero) {
          add(TotalDurationEvent(
              event.audios[event.index].waveformWrapper!.waveform.duration));
        }
      }
    });
    on<AudioEndEvent>((event, emit) {
      log('End Event Called : ${state.audios.length}');
      if (state.controller != null) state.controller!.dispose();
      emit(
        AudioEndState(
          controller: null,
          currentDuration: Duration.zero,
          totalDuration: Duration.zero,
          currentIndex: state.currentIndex,
          audios: state.audios,
          progressStream: state.progressStream,
        ),
      );
    });
    on<AudioPlayerStateChangedEvent>((event, emit) {
      log('AudioPlayerStateChanged Event');
      if (event.playerState == PlayerState.playing) {
        log('playing state emitted');
        emit(AudioPlayerStateChangedState(
          isPlaying: true,
          currentDuration: state.currentDuration,
          controller: state.controller,
          totalDuration: state.totalDuration,
          currentIndex: state.currentIndex,
          audios: state.audios,
          progressStream: state.progressStream,
        ));
      } else {
        log('pause state emitted');
        emit(AudioPlayerStateChangedState(
          isPlaying: false,
          currentDuration: state.currentDuration,
          controller: state.controller,
          totalDuration: state.totalDuration,
          currentIndex: state.currentIndex,
          audios: state.audios,
          progressStream: state.progressStream,
        ));
      }
    });
    on<AudioPositionChangedEvent>((event, emit) {
      emit(AudioPositionChangedState(
        currentDuration: event.currentDuration,
        controller: state.controller,
        totalDuration: state.totalDuration,
        currentIndex: state.currentIndex,
        audios: state.audios,
        progressStream: state.progressStream,
      ));
    });
    on<SwitchPlayerStateEvent>((event, emit) {
      log('Switch event called');
      if (state.controller == null) {
        throw ('contriller is null');
      } else {
        if (state.isPlaying) {
          state.controller!.pause();
          log('pause audio');
        } else {
          state.controller!.resume();
          log('resume audio');
        }
      }
    });
    on<TotalDurationEvent>((event, emit) {
      log('total Event Called : ${state.audios.length}');
      emit(TotalDurationState(
        controller: state.controller,
        currentDuration: state.currentDuration,
        totalDuration: event.totalDuration,
        currentIndex: state.currentIndex,
        audios: state.audios,
        progressStream: state.progressStream,
      ));
      log('total douration event called ${state.totalDuration.toString()}');
    });
    on<NextMusicEvent>((event, emit) {
      log('Next Event Called : ${state.audios.length}');
      add(AudioEndEvent());
      add(AudioInitEvent(
        state.audios,
        event.width,
        state.currentIndex + 1 < state.audios.length
            ? state.currentIndex + 1
            : 0,
      ));
    });
  }
}

void _init(
  String audioPath,
  BehaviorSubject<WaveformProgress> progressStream,
) async {
  log('generating waveform...');

  final audioFile = File(audioPath);
  try {
    // await audioFile.writeAsBytes(
    //     (await rootBundle.load(widget.audio.audioPath)).buffer.asUint8List());
    final waveFile = File(join((await getTemporaryDirectory()).path,
        '${extractFileName(audioPath)}.wave'));
    // final audioFile =
    //     File(p.join((await getTemporaryDirectory()).path, 'waveform.mp3'));
    // try {
    //   await audioFile.writeAsBytes(
    //       (await rootBundle.load('assets/audios/waveform.mp3'))
    //           .buffer
    //           .asUint8List());
    //   final waveFile =
    //       File(p.join((await getTemporaryDirectory()).path, 'waveform.wave'));
    JustWaveform.extract(
      audioInFile: audioFile,
      waveOutFile: waveFile,
    ).listen((data) {
      progressStream.add(data);
      if (data.waveform != null) {
        DataBaseService().storeWaveForm(
          AudioModel(
            audioPath: audioPath,
            waveformWrapper: WaveformWrapper(data.waveform!),
          ),
        );
      }
    }, onError: progressStream.addError);
  } catch (e) {
    progressStream.addError(e);
  }
}
