// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/indicator.dart';
import 'package:audio_player/viewes/audio/widgets/music_controller.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioView extends StatelessWidget {
  const AudioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) {
        if (current.changeType == ChangeType.initial) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        Track track = state.tracks.elementAt(state.currentIndex);
        return WillPopScope(
          onWillPop: () async {
            context.read<AudioBloc>().add(AudioEndEvent());

            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 10.w,
                    right: 10.w,
                    bottom: 20.h,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: 'heri',
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            height: 50.h,
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(Icons.horizontal_split,
                                          color: Theme.of(context).cardColor),
                                    ),
                                  ),
                                  Flexible(
                                      child: BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, homeState) {
                                      return InkWell(
                                        onTap: () {
                                          context.read<HomeBloc>().add(Favorite(
                                              !state.tracks
                                                  .elementAt(state.currentIndex)
                                                  .isFavorite,
                                              track.trackName));
                                        },
                                        child: Icon(
                                          state.tracks
                                                  .elementAt(state.currentIndex)
                                                  .isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Theme.of(context).cardColor,
                                        ),
                                      );
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Image.memory(state.tracks
                                  .elementAt(state.currentIndex)
                                  .coverImage),
                            ),
                          ),
                          const Spacer(),
                          const TrackTitle(),
                          const SizedBox(height: 15),
                          const MusicController(),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
