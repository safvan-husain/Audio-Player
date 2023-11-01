import 'package:audio_player/bloc/audio bloc/audio_bloc.dart';
import 'package:audio_player/bloc/home bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayListHeader extends StatelessWidget {
  final String playListName;
  const PlayListHeader({super.key, required this.playListName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      height: 200.h,
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          int numberOfSongs = state.trackList.length;
          int totalDuration = state.trackList.fold<int>(0,
              (value, element) => value + element.trackDuration.inMilliseconds);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                // height: 150.h,
                child: Row(
                  children: [
                    SizedBox(
                      height: 120.r,
                      width: 120.r,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          'assets/images/track.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.redAccent,

                        padding: EdgeInsets.symmetric(
                            horizontal: 25.w, vertical: 20.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playListName,
                              style: GoogleFonts.russoOne(
                                  color: Theme.of(context).focusColor,
                                  textStyle: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20.r)),
                            ),
                            Text(
                              '$numberOfSongs ${numberOfSongs > 1 ? "audios" : "audio"} : ${formatDuration(totalDuration)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.abc),
                                SizedBox(width: 10.w),
                                const Icon(Icons.abc),
                                SizedBox(width: 10.w),
                                const Icon(Icons.abc),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<AudioBloc, AudioState>(
                  builder: (context, audioState) {
                    return Row(
                      children: [
                        Button(
                          isOn: audioState.playerState == PlayerState.playing &&
                              audioState.tracks == state.trackList,
                          //show playing if the tracklist on both same.
                          label:
                              audioState.playerState == PlayerState.playing &&
                                      audioState.tracks == state.trackList
                                  ? "pause"
                                  : 'play',
                          icon: audioState.playerState == PlayerState.playing &&
                                  audioState.tracks == state.trackList
                              ? Icons.pause
                              : Icons.play_arrow,
                          onTap: () {
                            context
                                .read<AudioBloc>()
                                .add(PlayListPlayerStateSwitch(
                                  state.trackList,
                                  MediaQuery.of(context).size.width,
                                ));
                          },
                        ),
                        SizedBox(width: 10.r),
                        Button(
                          isOn: audioState.isShuffling,
                          label: 'shuffle',
                          icon: Icons.shuffle,
                          onTap: () {
                            context.read<AudioBloc>().add(SwitchShuffle());
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String formatDuration(int milliseconds) {
  var d = Duration(milliseconds: milliseconds);
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  if (d.inHours == 0) {
    return "$twoDigitMinutes minutes";
  }
  // String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
  return "${d.inHours} hour $twoDigitMinutes minutes";
}
