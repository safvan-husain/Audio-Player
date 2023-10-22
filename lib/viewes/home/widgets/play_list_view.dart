import 'dart:developer';

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
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/playlist.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(children: [
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            color: const Color.fromARGB(200, 145, 151, 174),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            playLists.elementAt(index),
                            style: GoogleFonts.russoOne(
                              color: Theme.of(context).splashColor,
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 25.r,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
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
