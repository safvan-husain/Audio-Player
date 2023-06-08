import 'package:audio_player/viewes/home/widgets/audio_tale.dart';
import 'package:flutter/material.dart';

class AudioList extends StatelessWidget {
  const AudioList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return AudioTale();
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 10),
    );
  }
}
