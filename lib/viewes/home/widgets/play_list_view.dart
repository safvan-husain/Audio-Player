import 'dart:developer';

import 'package:audio_player/common/outline_text.dart/text_custom_paint.dart';
import 'package:audio_player/common/theme_services.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayListView extends StatelessWidget {
  const PlayListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<String> playLists = [...state.playLists];

        return Container(
          padding: EdgeInsets.only(left: 10.r, right: 10.r, top: 10.r),
          height: 150.h,
          child: PageView.builder(
            padEnds: false,
            controller: PageController(
                viewportFraction: state.playLists.length == 1 ? 1.0 : 0.8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context
                      .read<HomeBloc>()
                      .add(RenderPlayList(playLists.elementAt(index)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ThemeService, bool>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/${!context.isDarkMode ? "lover.jpeg" : "fav-d.jpeg"}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(children: [
                          Positioned(
                            top: 75,
                            left: 10,
                            child: OutlinedText(
                                playLists.elementAt(index), context.isDarkMode),
                          )
                        ]),
                      );
                    },
                  ),
                ),
              );
            },
            itemCount: state.playLists.length,
          ),
        );
      },
    );
  }
}
