// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:audio_player/services/track_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_waveform/just_waveform.dart';

import 'package:audio_player/utils/audio_model.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/waveform.dart';

class MusicController extends StatelessWidget {
  final int index;
  final List<Track> tracks;
  const MusicController({
    Key? key,
    required this.index,
    required this.tracks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) =>
          current is AudioLoadedState ||
          current is AudioInitial ||
          current is AudioPlayerStateChangedState,
      builder: (context, state) {
        log('on music Controller : ${state.runtimeType}');
        return switch (state) {
          AudioLoadedState(controller: var controller) ||
          TotalDurationState(controller: var controller) ||
          AudioPlayerStateChangedState(controller: var controller) ||
          AudioPositionChangedState(controller: var controller) =>
            controller != null
                ? buildController(context, controller, state)
                : const Text('contriller is null'),
          _ => const Center(
              child: CircularProgressIndicator(),
            ),
        };
      },
    );
  }

  Column buildController(
    BuildContext context,
    AudioPlayer controller,
    AudioState state,
  ) {
    return Column(
      children: [
        if (tracks[index].waveformWrapper == null)
          _progressStreamBuilder(state, controller)
        else
          WaveFormControl(
            waveform: tracks[index].waveformWrapper!.waveform,
            player: state.controller!,
            isPlaying: state.isPlaying,
            currentDuration: state.currentDuration,
            color: Theme.of(context).splashColor,
            backgroundColor: Theme.of(context).focusColor,
          ),
        _buildController(context, state),
      ],
    );
  }

  StreamBuilder<WaveformProgress> _progressStreamBuilder(
      AudioState state, AudioPlayer? controller) {
    return StreamBuilder<WaveformProgress>(
      stream: state.progressStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          );
        }
        final progress = snapshot.data?.progress ?? 0.0;
        final waveform = snapshot.data?.waveform;

        if (waveform == null) {
          return Center(
            child: Text(
              '${(100 * progress).toInt()}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        } else if (controller == null) {
          //this might not suppose to be here.
          return const Center(
            child: Text('contriller iisn ull'),
          );
        } else {
          if (state.totalDuration == Duration.zero) {
            context
                .read<AudioBloc>()
                .add(TotalDurationEvent(waveform.duration));
          }

          return WaveFormControl(
            waveform: waveform,
            player: controller,
            isPlaying: state.isPlaying,
            currentDuration: state.currentDuration,
            color: Theme.of(context).splashColor,
            backgroundColor: Theme.of(context).focusColor,
          );
        }
      },
    );
  }

  Widget _buildController(BuildContext context, AudioState state) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 150.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.skip_previous_rounded),
            GestureDetector(
                onTap: () {
                  context.read<AudioBloc>().add(SwitchPlayerStateEvent());
                },
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Theme.of(context).splashColor,
                  child: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                )),
            InkWell(
                onTap: () {
                  context.read<AudioBloc>().add(ChangeMusicEvent(
                        MediaQuery.of(context).size.width,
                        state.tracks,
                        //if the index exceed the length start from beggning.
                        state.currentIndex + 1 < state.tracks.length
                            ? state.currentIndex + 1
                            : 0,
                      ));
                },
                child: const Icon(Icons.skip_next_rounded)),
          ],
        ),
      ),
    );
  }
}
