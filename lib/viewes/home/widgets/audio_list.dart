import 'package:audio_player/viewes/home/widgets/audio_tale.dart';
import 'package:flutter/material.dart';

class AudioList extends StatelessWidget {
  const AudioList({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> audioPaths = [
      'audios/aaro.mp3',
      'audios/adam_john.mp3',
      'audios/bgm.mp3',
      // Add more audio file paths
    ];
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return AudioTale(
              audioPath: audioPaths[index],
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: audioPaths.length),
    );
  }
}
