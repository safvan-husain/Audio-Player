import 'package:audio_player/viewes/drawer/bloc/drawer_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayListView extends StatelessWidget {
  const PlayListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => current is DrawerStateChange,
      builder: (context, state) {
        List<String> playLists = [...state.playLists];

        return Container(
          padding: EdgeInsets.only(left: 10.r, right: 10.r, top: 10.r),
          height: 150.h,
          child: LayoutBuilder(
            builder: (context, constrains) => PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // if (index == 0) {
                //   return GestureDetector(
                //     onTap: () {
                //       context
                //           .read<HomeBloc>()
                //           .add(RenderPlayList(playLists.elementAt(index)));
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Container(
                //         width: state.playLists.length == 1
                //             ? MediaQuery.of(context).size.width - 20.r
                //             : constrains.maxWidth * 0.8,
                //         decoration: const BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(4)),
                //           image: DecorationImage(
                //             image: AssetImage('assets/images/favorite.jpg'),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                // }
                return GestureDetector(
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(RenderPlayList(playLists.elementAt(index)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: state.playLists.length == 1
                          ? MediaQuery.of(context).size.width - 20.r
                          : constrains.maxWidth * 0.8,
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
                              color: Colors.transparent,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              playLists.elementAt(index),
                              style: Theme.of(context).textTheme.titleLarge,
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
          ),
        );
      },
    );
  }
}
