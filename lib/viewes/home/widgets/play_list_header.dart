import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/button.dart';
import 'package:audio_player/viewes/home/widgets/processing_download/pop_up_route.dart';
import 'package:audio_player/viewes/home/widgets/processing_download/pop_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayListHeader extends StatelessWidget {
  const PlayListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      height: 200.h,
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                // height: 150.h,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(PopUpRoute(const DownloadDailogue()));
                      },
                      child: SizedBox(
                        height: 120.r,
                        width: 120.r,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            'assets/images/pop2.jpeg',
                            fit: BoxFit.cover,
                          ),
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
                              state.playList,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '${state.trackList.length} ${state.trackList.length > 1 ? "songs" : "song"} : 6 hour 50 miniutres',
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
                          //show playing if the tracklist on both same.
                          label: audioState.isPlaying &&
                                  audioState.tracks == state.trackList
                              ? "pause"
                              : 'play',
                          icon: audioState.isPlaying &&
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
