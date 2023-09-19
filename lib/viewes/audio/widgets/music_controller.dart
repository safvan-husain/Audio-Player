// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MusicController extends StatefulWidget {
  const MusicController({Key? key}) : super(key: key);

  @override
  State<MusicController> createState() => _MusicControllerState();
}

class _MusicControllerState extends State<MusicController> {
  bool isPlaying = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return switch (state) {
          AudioLoadedState(controller: var controller) =>
            buildController(context, controller, state),
          AudioInitial() || AudioEndState() => const Center(
              child: CircularProgressIndicator(),
            )
        };
      },
    );
  }

  Column buildController(
      BuildContext context, PlayerController? controller, AudioState state) {
    return Column(
      children: [
        AudioFileWaveforms(
          size: Size(MediaQuery.of(context).size.width, 100.0),
          playerController: controller!,
          enableSeekGesture: true,
          waveformType: WaveformType.fitWidth,
          // waveformData: snapshot.data!,
        ),
        SizedBox(
          width: 150.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.skip_previous_rounded),
              InkWell(
                  onTap: () {
                    if (isPlaying) {
                      controller.pausePlayer();
                      log('paused');
                    } else {
                      controller.startPlayer();
                      log('resumed');
                    }
                    isPlaying = !isPlaying;
                  },
                  child: CircleAvatar(
                    radius: 25.r,
                    child: const Icon(Icons.pause),
                  )),
              InkWell(
                  onTap: () {
                    controller.seekTo(state.currentDuration + 50000);
                    log('seeking');
                  },
                  child: const Icon(Icons.skip_next_rounded)),
            ],
          ),
        ),
      ],
    );
  }
}
