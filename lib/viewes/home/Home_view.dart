import 'package:audio_player/common/icon_box.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(RenderMusicHomeEvent());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 46, 36, 76),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (ctx, state) {
              return switch (state) {
                HomeInitial() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                HomeLoaded(audioList: var paths) => AudioList(paths: paths),
              };
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await getFilePath();
        context.read<HomeBloc>().add(RenderMusicHomeEvent());
      }),
    );
  }

  Row builtSearchBar() {
    return Row(
      children: [
        const Expanded(
          child: IconBox(icon: Icons.receipt),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 109, 92, 161),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 100,
            height: 50,
            child: const TextField(
              decoration: InputDecoration(
                  hintText: 'search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
        )
      ],
    );
  }
}
