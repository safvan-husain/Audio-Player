import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee_text/marquee_text.dart';

class TrackTitle extends StatefulWidget {
  const TrackTitle({super.key});

  @override
  State<TrackTitle> createState() => _TrackTitleState();
}

class _TrackTitleState extends State<TrackTitle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        Track track = state.tracks.elementAt(state.currentIndex);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MarqueeText(
              speed: 20,
              text: TextSpan(
                text: cutString(track.trackName),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              track.trackDetail,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
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

String cutString(String input) {
  RegExp regExp = RegExp(r'^[a-zA-Z0-9 ,]*');
  Match? match = regExp.firstMatch(input);
  String output = match?.group(0) ?? '';
  return output.length < 10 ? input.trim() : output.trim();
}
