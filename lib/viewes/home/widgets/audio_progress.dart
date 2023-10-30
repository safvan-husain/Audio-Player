import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioProgress extends StatelessWidget {
  const AudioProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        int duration = state.tracks
            .elementAt(state.currentIndex)
            .trackDuration
            .inMilliseconds;
        return GestureDetector(
          onTapDown: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset position = box.globalToLocal(details.globalPosition);
            double ratio = position.dx / box.size.width;
            Duration timestamp =
                Duration(milliseconds: (ratio * duration).round());
            state.audioHandler!.seek(timestamp);
          },
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).canvasColor,
            color: Theme.of(context).splashColor,
            value: state.currentDuration.inMilliseconds / duration,
          ),
        );
      },
    );
  }
}
