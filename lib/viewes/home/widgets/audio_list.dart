// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:audio_player/model/track_model.dart';
import 'package:audio_player/bloc/audio bloc/audio_bloc.dart';
import 'package:flutter/material.dart';

import 'package:audio_player/viewes/home/widgets/audio_tale.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioList extends StatelessWidget {
  final List<Track> tracks;

  const AudioList({
    Key? key,
    required this.tracks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 5.r),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<AudioBloc>().add(
                    AudioInitEvent(
                      tracks,
                      index,
                      MediaQuery.of(context).size.width,
                    ),
                  );
            },
            child: AudioTale(
              track: tracks[index],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: tracks.length,
      ),
    );
  }
}
