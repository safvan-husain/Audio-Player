import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/home/widgets/processing_download/pop_up_route.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/dailogue.dart';
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
      builder: (context, state) {
        if (state.controller == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return buildController(context, state);
      },
    );
  }

  Column buildController(
    BuildContext context,
    AudioState state,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                formatDuration(state.currentDuration),
                style: Theme.of(context).textTheme.titleMedium,
              )),
              Flexible(
                  child: Text(
                formatDuration(
                    state.tracks.elementAt(state.currentIndex).trackDuration),
                style: Theme.of(context).textTheme.titleMedium,
              )),
            ],
          ),
        ),
        SizedBox(height: 10.h),
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
        } else {
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
    double width = MediaQuery.of(context).size.width;
    Track track = state.tracks.elementAt(state.currentIndex);
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: InkWell(
                onTap: () {
                  String trackName = track.trackName;
                  context
                      .read<PlayListWindowBloc>()
                      .add(LoadPlayLists(trackName, () {
                        Navigator.of(context).push(
                          PopUpRoute(PlayListDailogue(trackName)),
                        );
                      }));
                },
                child: const Icon(Icons.playlist_add)),
          ),
          SizedBox(
            width: 150.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<AudioBloc>()
                        .add(ChangeMusicEvent.previous(state, width));
                  },
                  child: const Icon(Icons.skip_previous_rounded),
                ),
                GestureDetector(
                    onTap: () {
                      context.read<AudioBloc>().add(SwitchPlayerStateEvent());
                    },
                    child: CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Theme.of(context).splashColor,
                      child: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow),
                    )),
                InkWell(
                  onTap: () {
                    context
                        .read<AudioBloc>()
                        .add(ChangeMusicEvent.next(state, width));
                  },
                  child: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
          ),
          Flexible(
              child: InkWell(
            onTap: () {
              context.read<AudioBloc>().add(SwitchShuffle());
            },
            child: Icon(
                state.isShuffling ? Icons.shuffle_on_outlined : Icons.shuffle),
          )),
        ],
      ),
    );
  }
}

String formatDuration(Duration d) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
  if (d.inHours == 0) {
    return "$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
