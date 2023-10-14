import 'dart:math';

import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/audio/audio_view.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioControl extends StatefulWidget {
  const AudioControl({
    Key? key,
  }) : super(key: key);

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  bool isVisible = false;
  late Track track;
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() => isVisible = true);
      },
    );
    super.initState();
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
              child: Card(
                color: Theme.of(context).cardColor,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  height: 50.h,
                  child: BlocBuilder<AudioBloc, AudioState>(
                    builder: (context, state) {
                      print(
                          'state playing: ${state.isPlaying} : ${state.changeType}');
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
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              state.tracks.elementAt(state.currentIndex).trackName,
              style: Theme.of(context).textTheme.titleSmall,
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
                        context.read<AudioBloc>().add(SwitchPlayerStateEvent());
                      },
                      child: Icon(
                        state.isPlaying
                            ? Icons.pause_circle_filled_outlined
                            : Icons.play_arrow_outlined,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) => current is HomeLoaded,
                      builder: (context, homeState) {
                        return InkWell(
                          onTap: () {},
                          child: Icon(
                            state.tracks
                                    .elementAt(state.currentIndex)
                                    .isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color.fromARGB(255, 240, 45, 58),
                          ),
                        );
                      },
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
