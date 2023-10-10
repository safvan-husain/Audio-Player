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
    return BlocBuilder<DrawerBloc, DrawerState>(
      buildWhen: (previous, current) => current is DrawerStateChange,
      builder: (context, state) {
        List<String> playLists = ["All", ...state.playLists];
        return SizedBox(
          height: state.isPlayListExtended
              ? (85.h * (playLists.length / 2).ceil()) + 40.h
              : 125.h,
          child: Card(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: state.isPlayListExtended
                        ? 85.h * (playLists.length / 2).ceil()
                        : 85.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5.r,
                        crossAxisSpacing: 5.r,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: state.isPlayListExtended
                          ? playLists.length
                          : playLists.length > 2
                              ? 2
                              : playLists.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              context
                                  .read<HomeBloc>()
                                  .add(RenderTracksFromApp());
                            } else {
                              context.read<HomeBloc>().add(
                                  RenderPlayList(playLists.elementAt(index)));
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              image: DecorationImage(
                                image: AssetImage('assets/images/pop2.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(children: [
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(playLists.elementAt(index)),
                                ),
                              )
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<DrawerBloc>()
                            .add(SwitchPlayListExtendedness());
                      },
                      child: const Text('see more'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
