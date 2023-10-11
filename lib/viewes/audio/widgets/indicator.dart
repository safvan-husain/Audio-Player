import 'dart:developer';

import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
// import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart'
    as s;
import 'package:audio_player/viewes/playlist_pop_up_window/dailogue.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/pop_up_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Indicators extends StatefulWidget {
  const Indicators({super.key});

  @override
  State<Indicators> createState() => _IndicatorsState();
}

class _IndicatorsState extends State<Indicators> {
  late final AudioBloc _audioBloc = context.read<AudioBloc>();
  late final Track track =
      _audioBloc.state.tracks.elementAt(_audioBloc.state.currentIndex);
  bool isFavorite = false;
  @override
  void initState() {
    isFavorite = track.isFavorite;
    super.initState();
  }

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
                              String trackName = track.trackName;
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
                          setState(() => isFavorite = !isFavorite);
                          context
                              .read<HomeBloc>()
                              .add(Favorite(isFavorite, track.trackName));
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_outline,
                          color: Colors.redAccent,
                        ),
                      )),
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
