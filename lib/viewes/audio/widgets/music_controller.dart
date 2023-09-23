// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/utils/waveform_extension.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'package:audio_player/utils/audio_model.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/waveform.dart';

class MusicController extends StatefulWidget {
  final int index;
  final List<AudioModel> paths;
  const MusicController({
    Key? key,
    required this.index,
    required this.paths,
  }) : super(key: key);

  @override
  State<MusicController> createState() => _MusicControllerState();
}

class _MusicControllerState extends State<MusicController> {
  final progressStream = BehaviorSubject<WaveformProgress>();
  @override
  void initState() {
    // if (widget.paths[widget.index].waveformWrapper == null) {
    //   _init(context);
    // } else {
    //   context.read<AudioBloc>().add(TotalDurationEvent(
    //       widget.paths[widget.index].waveformWrapper!.waveform.duration));
    // }

    super.initState();
  }

  void _init(BuildContext context) async {
    log('generating waveform...');

    final audioFile = File(widget.paths[widget.index].audioPath);
    try {
      // await audioFile.writeAsBytes(
      //     (await rootBundle.load(widget.audio.audioPath)).buffer.asUint8List());
      final waveFile = File(p.join((await getTemporaryDirectory()).path,
          '${extractFileName(widget.paths[widget.index].audioPath)}.wave'));
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
              audioPath: widget.paths[widget.index].audioPath,
              waveformWrapper: WaveformWrapper(data.waveform!),
            ),
          );
        }
      }, onError: progressStream.addError);
    } catch (e) {
      progressStream.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) =>
          current is AudioLoadedState || current is AudioInitial,
      builder: (context, state) {
        return switch (state) {
          AudioLoadedState(controller: var controller) ||
          TotalDurationState(controller: var controller) =>
            buildController(context, controller, state.currentDuration, state),
          AudioInitial() || AudioEndState() => const Center(
              child: CircularProgressIndicator(),
            ),
          _ => const Center(
              child: CircularProgressIndicator(),
            ),
        };
      },
    );
  }

  Column buildController(
    BuildContext context,
    AudioPlayer? controller,
    Duration currentDuration,
    AudioState state,
  ) {
    return Column(
      children: [
        if (widget.paths[widget.index].waveformWrapper == null)
          StreamBuilder<WaveformProgress>(
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
                return const Center(
                  child: Text('contriller iisn ull'),
                );
              } else {
                if (state.totalDuration == Duration.zero) {
                  log('total duration calling');
                  context
                      .read<AudioBloc>()
                      .add(TotalDurationEvent(waveform.duration));
                }

                return WaveFormControl(
                  waveform: waveform,
                  player: controller,
                  isPlaying: state.isPlaying,
                  currentDuration: currentDuration,
                );
              }
            },
          ),
        if (widget.paths[widget.index].waveformWrapper != null)
          WaveFormControl(
            waveform: widget.paths[widget.index].waveformWrapper!.waveform,
            player: state.controller!,
            isPlaying: state.isPlaying,
            currentDuration: currentDuration,
          ),
        SizedBox(
          width: 150.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.skip_previous_rounded),
              InkWell(
                  onTap: () {
                    context.read<AudioBloc>().add(SwitchPlayerStateEvent());
                  },
                  child: CircleAvatar(
                    radius: 25.r,
                    child: const Icon(Icons.pause),
                  )),
              InkWell(
                  onTap: () {
                    context.read<AudioBloc>().add(NextMusicEvent(
                        widget.paths[widget.index + 1].audioPath,
                        MediaQuery.of(context).size.width));
                  },
                  child: const Icon(Icons.skip_next_rounded)),
            ],
          ),
        ),
      ],
    );
  }
}
