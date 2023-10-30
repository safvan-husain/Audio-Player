import 'dart:async';

import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/audio/audio_view.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_progress.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioControl extends StatefulWidget {
  const AudioControl({
    Key? key,
  }) : super(key: key);

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  bool isVisible = false;
  bool isFavorite = false;
  late Track track;
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() => isVisible = true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    track = context
        .read<AudioBloc>()
        .state
        .tracks
        .elementAt(context.read<AudioBloc>().state.currentIndex);
    return Visibility(
      visible: isVisible,
      child: Positioned(
        bottom: 10,
        left: 0,
        right: 0,
        child: Hero(
          tag: 'heri',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => const AudioView()));
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  context.read<AudioBloc>().add(AudioEndEvent());
                }
              },
              child: Card(
                color: Theme.of(context).cardColor,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  height: 50.h,
                  child: BlocBuilder<AudioBloc, AudioState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNameAndButtons(context, state),
                          const AudioProgress(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndButtons(BuildContext context, AudioState state) {
    Track track = state.tracks.elementAt(state.currentIndex);
    List<Track> tracksHome = context
        .watch<HomeBloc>()
        .state
        .trackList
        .where((element) =>
            element.trackName ==
            state.tracks.elementAt(state.currentIndex).trackName)
        .toList();

    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              state.tracks.elementAt(state.currentIndex).trackName,
              style: GoogleFonts.poppins(
                  color: Theme.of(context).splashColor,
                  textStyle: TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: 14.r)),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        context.read<AudioBloc>().add(SwitchPlayerStateEvent(
                            MediaQuery.of(context).size.width));
                      },
                      child: Icon(
                        state.isPlaying == PlayerState.playing
                            ? Icons.pause_circle_filled_outlined
                            : Icons.play_arrow_outlined,
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(Favorite(
                            !state.tracks
                                .elementAt(state.currentIndex)
                                .isFavorite,
                            track.trackName));
                      },
                      child: Icon(
                        (tracksHome.isNotEmpty
                                ? tracksHome[0].isFavorite
                                : state.tracks
                                    .elementAt(state.currentIndex)
                                    .isFavorite)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
