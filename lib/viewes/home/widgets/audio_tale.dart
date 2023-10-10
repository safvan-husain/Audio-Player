import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioTale extends StatefulWidget {
  final Track track;

  const AudioTale({Key? key, required this.track}) : super(key: key);

  @override
  State<AudioTale> createState() => _AudioTaleState();
}

class _AudioTaleState extends State<AudioTale> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    isFavorite = widget.track.isFavorite;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                'assets/images/pop2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.track.trackName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.track.trackDetail,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              context
                  .read<HomeBloc>()
                  .add(Favorite(isFavorite, widget.track.trackName));
            },
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}
