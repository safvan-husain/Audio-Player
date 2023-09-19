import 'dart:developer';

import 'package:audio_player/viewes/home/widgets/audio_controll.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc() : super(AudioInitial(currentDuration: 0)) {
    on<AudioInitEvent>((event, emit) async {
      var controller = PlayerController();
      await controller.preparePlayer(
        path: event.audioPath,
        shouldExtractWaveform: true,
        noOfSamples: const PlayerWaveStyle().getSamplesForWidth(event.width),
        volume: 1.0,
      );
      await controller.startPlayer(finishMode: FinishMode.stop);
      controller.onCurrentDurationChanged.listen((duration) {
        state.currentDuration = duration;
        // log('duration change $duration');
      });
      emit(AudioLoadedState(
          controller: controller, currentDuration: state.currentDuration));
      final duration = await controller.getDuration(DurationType.max);
      log('get $duration');
    });
    on<AudioEndEvent>((event, emit) {
      log('emd called');
      if (state.controller != null) {
        state.controller!.stopPlayer();
        state.controller!.dispose();
      }

      emit(
        AudioEndState(
          controller: null,
          currentDuration: state.currentDuration,
        ),
      );
    });
  }
}
