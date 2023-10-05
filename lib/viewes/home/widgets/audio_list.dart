// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:flutter/material.dart';

import 'package:audio_player/viewes/home/widgets/audio_tale.dart';

class AudioList extends StatelessWidget {
  final List<Track> tracks;
  const AudioList({
    Key? key,
    required this.tracks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return AudioTale(
          index: index,
          tracks: tracks,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: tracks.length,
    );
  }
}
