// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/utils/audio_model.dart';
import 'package:audio_player/viewes/audio/audio_view.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

import 'package:audio_player/viewes/home/widgets/audio_tale.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return InkWell(
          onLongPress: () {
            DataBaseService().deleteTrack(tracks[index].trackName);
            context.read<HomeBloc>().add(RenderTracksFromApp());
          },
          onTap: () {
            if (context.read<AudioBloc>().state.controller == null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AudioView()),
              );
            }
            context.read<AudioBloc>().add(
                  AudioInitEvent(
                      tracks, index, MediaQuery.of(context).size.width, () {}),
                );
          },
          child: AudioTale(
            track: tracks[index],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: tracks.length,
    );
  }
}
