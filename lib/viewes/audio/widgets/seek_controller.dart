import 'dart:developer';

import 'package:audio_player/bloc/audio bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeekController extends StatelessWidget {
  const SeekController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            log('tap');
          },
          onTapDown: (details) async {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset position = box.globalToLocal(details.globalPosition);
            // position.dx gives you the x-coordinate of the touch event
            // You can then calculate the timestamp based on this x-coordinate
            double ratio = position.dx / box.size.width;
            Duration timestamp = Duration(
                milliseconds: (ratio *
                        state.tracks
                            .elementAt(state.currentIndex)
                            .trackDuration
                            .inMilliseconds)
                    .round());
            await state.audioHandler.player.seek(timestamp);
          },
          child: () {
            if (state.tracks.elementAt(state.currentIndex).waveformWrapper ==
                null) {
              return Material(
                elevation: 0,
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: LinearProgressIndicator(
                    color: Theme.of(context).focusColor,
                    backgroundColor: Theme.of(context).cardColor,
                    value: state.currentDuration.inMilliseconds /
                        state.tracks
                            .elementAt(state.currentIndex)
                            .trackDuration
                            .inMilliseconds,
                  ),
                ),
              );
            }
            return WaveFormVisulizer(
              waveform: state.tracks
                  .elementAt(state.currentIndex)
                  .waveformWrapper!
                  .waveform,
              currentDuration: state.currentDuration,
            );
          }(),
        );
      },
    );
  }
}
