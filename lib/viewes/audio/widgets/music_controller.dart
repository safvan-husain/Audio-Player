import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_waveform/just_waveform.dart';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/waveform.dart';

class MusicController extends StatelessWidget {
  const MusicController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) =>
          current.changeType == ChangeType.trackLoaded ||
          current.changeType == ChangeType.initial ||
          current.changeType == ChangeType.playerState,
      builder: (context, state) {
        print(state.changeType);
        return switch (state.changeType) {
          // ChangeType.initial => const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          _ => state.controller != null
              ? buildController(context, state)
              : const Text('contriller is null'),
        };
      },
    );
  }

  Column buildController(
    BuildContext context,
    AudioState state,
  ) {
    return Column(
      children: [
        if (state.tracks.elementAt(state.currentIndex).waveformWrapper == null)
          _progressStreamBuilder(state)
        else
          WaveFormControl(
            waveform: state.tracks
                .elementAt(state.currentIndex)
                .waveformWrapper!
                .waveform,
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

  StreamBuilder<WaveformProgress> _progressStreamBuilder(AudioState state) {
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
        } else if (state.controller == null) {
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
            player: state.controller!,
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
                  print(state.isPlaying);
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
                        state.tracks,
                        //if the index exceed the length start from beggning.
                        state.currentIndex > state.tracks.length - 2
                            ? 0
                            : state.currentIndex + 1,
                        MediaQuery.of(context).size.width,
                      ));
                },
                child: const Icon(Icons.skip_next_rounded)),
          ],
        ),
      ),
    );
  }
}
