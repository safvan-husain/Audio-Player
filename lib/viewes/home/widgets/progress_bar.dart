import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/audio_player_provider.dart';
import '../../../services/audio_services.dart';
import '../../../utils/audio_name.dart';

class AudioControl extends StatefulWidget {
  final String audioPath;
  final AudioServices player;
  AudioControl({Key? key, required this.audioPath})
      : player = AudioServices(audioPath: audioPath),
        super(key: key);

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  bool isPlaying = false;
  Duration dur = const Duration(milliseconds: 000);
  bool isDispose = true;

  @override
  void dispose() async {
    isDispose = false;
    super.dispose();
    await widget.player.player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.player.player.onPositionChanged.listen((Duration p) {
      if (isDispose) {
        setState(() {
          dur = p;
        });
      }
    });
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 70,
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
                  progress: dur,
                  buffered: const Duration(milliseconds: 000),
                  total: snapshot.data!,
                  onSeek: (duration) {
                    print('User selected a new time: $duration');
                  },
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  extractFileName(widget.audioPath),
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isPlaying) {
                            widget.player.pause();
                          } else {
                            widget.player.play();
                          }
                          log(extractFileName(widget.audioPath));
                          isPlaying = !isPlaying;
                        },
                        child: const Icon(Icons.play_arrow_outlined),
                      ),
                      InkWell(
                        onTap: () {
                          // widget.player.stop();
                          log(extractFileName(widget.audioPath));
                          Provider.of<AudioPlayerProvider>(context,
                                  listen: false)
                              .stopAudio(extractFileName(widget.audioPath));
                        },
                        child: const Icon(Icons.stop_circle_outlined),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
