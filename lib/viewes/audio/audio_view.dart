// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/audio/widgets/indicator.dart';
import 'package:audio_player/viewes/audio/widgets/music_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioView extends StatelessWidget {
  const AudioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (previous, current) {
        return false;
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            try {
              context.read<AudioBloc>().add(AudioEndEvent());
            } catch (e) {
              throw ('Exception thrown: $e');
            }
            return true;
          },
          child: Scaffold(
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
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            height: 50.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.horizontal_split),
                                ),
                                const InkWell(
                                  child: Icon(Icons.search),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                              future: extractTrackDetails(state.tracks
                                  .elementAt(state.currentIndex)
                                  .trackUrl),
                              builder: (context, snp) {
                                if (snp.hasData) {
                                  if (snp.data!.albumArt != null) {
                                    return Image.memory(
                                      snp.data!.albumArt!,
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    );
                                  }

                                  return Image.asset(
                                    'assets/images/pop2.jpeg',
                                    fit: BoxFit.cover,
                                  );
                                }
                                return Image.asset(
                                  'assets/images/pop2.jpeg',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                          Indicators(),
                          const MusicController()
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

Future<Metadata> extractTrackDetails(String trackUrl) async {
  final metadata = await MetadataRetriever.fromFile(
    File(trackUrl),
  );
  return metadata;
}
