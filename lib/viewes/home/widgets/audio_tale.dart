import 'dart:developer';
import 'dart:io';

import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioTale extends StatefulWidget {
  final Track track;

  const AudioTale({Key? key, required this.track}) : super(key: key);

  @override
  State<AudioTale> createState() => _AudioTaleState();
}

class _AudioTaleState extends State<AudioTale> {
  bool isFavorite = false;

  Future<Metadata> extractTrackDetails() async {
    final metadata = await MetadataRetriever.fromFile(
      File(widget.track.trackUrl),
    );
    return metadata;
  }

  @override
  Widget build(BuildContext context) {
    isFavorite = widget.track.isFavorite;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            height: 80.r,
            child: FutureBuilder(
              future: extractTrackDetails(),
              builder: (context, snp) {
                if (snp.hasData) {
                  if (snp.data!.albumArt != null) {
                    return Image.memory(
                      snp.data!.albumArt!,
                      fit: BoxFit.fitHeight,
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
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cutString(widget.track.trackName),
                  maxLines: 2,
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
      // child: Container(
      //   color: Colors.blueAccent,
      //   // height: 80.r,
      //   width: 80.w,
      //   child: FutureBuilder(
      //     future: extractTrackDetails(),
      //     builder: (context, snp) {
      //       if (snp.hasData) {
      //         if (snp.data!.albumArt != null) {
      //           return Container(
      //             color: Colors.redAccent,
      //             child: Image.memory(
      //               snp.data!.albumArt!,
      //               fit: BoxFit.fill,
      //             ),
      //           );
      //         }
      //         return Image.asset(
      //           'assets/images/pop2.jpeg',
      //           fit: BoxFit.cover,
      //         );
      //       }
      //       return Image.asset(
      //         'assets/images/pop2.jpeg',
      //         fit: BoxFit.cover,
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

String cutString(String input) {
  RegExp regExp = RegExp(r'^[a-zA-Z0-9 ,]*');
  Match? match = regExp.firstMatch(input);
  String output = match?.group(0) ?? '';
  return output.length < 10 ? input : output;
}
