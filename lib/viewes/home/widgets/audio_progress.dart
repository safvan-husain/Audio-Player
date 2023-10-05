import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioProgress extends StatelessWidget {
  const AudioProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset position = box.globalToLocal(details.globalPosition);
            // position.dx gives you the x-coordinate of the touch event
            // You can then calculate the timestamp based on this x-coordinate
            double ratio = position.dx / box.size.width;
            Duration timestamp = Duration(
                milliseconds:
                    (ratio * state.totalDuration.inMilliseconds).round());
            print("Touched at ${timestamp.inSeconds} seconds");
            state.controller!.seek(timestamp);
          },
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).splashColor,
            color: Theme.of(context).focusColor,
            value: state.totalDuration == Duration.zero
                ? null
                : state.currentDuration.inMilliseconds /
                    state.totalDuration.inMilliseconds,
          ),
        );
      },
    );
  }
}
