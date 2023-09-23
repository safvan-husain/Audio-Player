import 'dart:developer';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                  Icon(Icons.abc),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(state.currentDuration)),
                  Text(formatDuration(state.totalDuration)),
                ],
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
