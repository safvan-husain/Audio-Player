import 'package:audio_player/provider/faviourate_audio_provider.dart';
import 'package:audio_player/viewes/favourite/widgets/favourite_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/icon_box.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 36, 76),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _builtAppBar(),
            const SizedBox(height: 20),
            const Text(
              'Recent favourites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (context.watch<FavouriteAudioProvider>().audioPaths.isNotEmpty)
              builtFavourites(context)
            else
              const Center(
                child: Text(
                  "You have no favourites",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      )),
    );
  }

  Expanded builtFavourites(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          itemCount: context.watch<FavouriteAudioProvider>().audioPaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return FavouriteAudio(
                audioPath:
                    context.watch<FavouriteAudioProvider>().audioPaths[index]);
          }),
    );
  }

  Row _builtAppBar() {
    return const Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: IconBox(icon: Icons.arrow_back_ios_new),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconBox(
              icon: Icons.favorite_outline,
            ),
          ),
        ),
      ],
    );
  }
}
