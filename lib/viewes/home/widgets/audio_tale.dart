import 'package:audio_player/model/track_model.dart';
import 'package:audio_player/bloc/home bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
          SizedBox(
            height: 80.r,
            child: Image.memory(
              widget.track.coverImage,
              fit: BoxFit.fitHeight,
              gaplessPlayback: true,
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
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).focusColor,
                    textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 16.r),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.track.trackDetail,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).cardColor,
                      textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 12.r)),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Theme.of(context).cardColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

String cutString(String input) {
  RegExp regExp = RegExp(r'^[a-zA-Z0-9 ,]*');
  Match? match = regExp.firstMatch(input);
  String output = match?.group(0) ?? '';
  return output.length < 10 ? input : output;
}
