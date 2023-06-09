// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/audio_player_provider.dart';
import '../../../services/audio_services.dart';

class AudioControl extends StatefulWidget {
  final String audioPath;
  final AudioServices player;

  const AudioControl({
    Key? key,
    required this.player,
    required this.audioPath,
  }) : super(key: key);

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  bool isPlaying = false;
  Duration duration = const Duration(milliseconds: 000);
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  PlayerState currentAudioState = PlayerState.paused;

  @override
  Widget build(BuildContext context) {
    widget.player.player.onPositionChanged.listen((Duration p) {
      if (!isDisposed) {
        setState(() {
          duration = p;
        });
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          FutureBuilder(
            future: widget.player.player.getDuration(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ProgressBar(
                    progress: Duration(milliseconds: 000),
                    total: Duration(milliseconds: 000));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ProgressBar(
                  progress: duration,
                  buffered: const Duration(milliseconds: 000),
                  total: snapshot.data!,
                );
              }
            },
          ),
          _built_name_play_pause(context),
        ],
      ),
    );
  }

  Padding _built_name_play_pause(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            extractFileName(widget.audioPath),
            style: const TextStyle(
              color: Color.fromARGB(255, 35, 62, 110),
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    widget.player.player.onPlayerStateChanged
                        .listen((PlayerState s) {
                      currentAudioState = s;
                    });
                    if (currentAudioState == PlayerState.playing) {
                      widget.player.pause();
                    } else {
                      widget.player.play();
                    }
                    isPlaying = !isPlaying;
                    setState(() {});
                  },
                  child: Icon(currentAudioState == PlayerState.playing
                      ? Icons.pause_circle_filled_outlined
                      : Icons.play_arrow_outlined),
                ),
                InkWell(
                  onTap: () {
                    Provider.of<AudioPlayerProvider>(context, listen: false)
                        .stopAudio(widget.audioPath);
                  },
                  child: const Icon(Icons.stop_circle_outlined),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
