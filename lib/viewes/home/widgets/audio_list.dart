// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:audio_player/viewes/home/widgets/audio_tale.dart';

class AudioList extends StatelessWidget {
  final List<String> paths;
  const AudioList({
    Key? key,
    required this.paths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return AudioTale(
          audioPath: paths[index],
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: paths.length,
    );
  }
}
