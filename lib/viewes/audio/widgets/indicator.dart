import 'package:audio_player/model/track_model.dart';
import 'package:audio_player/bloc/audio bloc/audio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
                style: GoogleFonts.russoOne(
                  color: Theme.of(context).focusColor,
                  textStyle: TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: 20.r),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              track.trackDetail,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: GoogleFonts.poppins(
                  color: Theme.of(context).cardColor,
                  textStyle: TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: 12.r),
                  decoration: TextDecoration.none),
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
