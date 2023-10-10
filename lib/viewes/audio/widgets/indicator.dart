import 'dart:developer';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
// import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart'
    as s;
import 'package:audio_player/viewes/playlist_pop_up_window/dailogue.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/pop_up_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Indicators extends StatelessWidget {
  const Indicators({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) =>
          current.runtimeType == TotalDurationState ||
          current.runtimeType == AudioPositionChangedState,
      builder: (context, state) {
        return SizedBox(
          height: 100.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: InkWell(
                            onTap: () {
                              String trackName = context
                                  .read<AudioBloc>()
                                  .homeBloc
                                  .state
                                  .trackList[state.currentIndex]
                                  .trackName;
                              context
                                  .read<s.PlayListWindowBloc>()
                                  .add(s.LoadPlayLists(trackName, () {
                                    Navigator.of(context).push(
                                      PopUpRoute(PlayListDailogue(trackName)),
                                    );
                                  }));
                            },
                            child: const Icon(Icons.playlist_add)),
                      ),
                      const Flexible(child: Icon(Icons.shuffle)),
                      const Flexible(child: Icon(Icons.repeat)),
                      Flexible(
                          child: InkWell(
                              onTap: () {
                                context
                                    .read<AudioBloc>()
                                    .add(AddTrackToFavorites());
                              },
                              child: Icon(Icons.favorite))),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                      formatDuration(state.currentDuration),
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                    Flexible(
                        child: Text(
                      formatDuration(state.totalDuration),
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String formatDuration(Duration d) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
  if (d.inHours == 0) {
    return "$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
