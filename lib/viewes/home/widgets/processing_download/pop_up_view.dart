import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadDailogue extends StatelessWidget {
  const DownloadDailogue({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.poppins(
        color: Theme.of(context).splashColor,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 13.r));
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          type: MaterialType.transparency,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: BlocBuilder<PlayListWindowBloc, PlayListWindowState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(15.r),
                width: MediaQuery.of(context).size.width / 1.5,
                // height: 180.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Warning',
                      style: GoogleFonts.russoOne(
                          color: Theme.of(context).splashColor,
                          textStyle: TextStyle(
                              overflow: TextOverflow.ellipsis, fontSize: 18.r)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: const Divider(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. ',
                              style: textStyle,
                            ),
                            Flexible(
                              child: Text(
                                'Do not download apk file',
                                style: textStyle,
                                maxLines: 3,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2. ',
                              style: textStyle,
                            ),
                            Flexible(
                              child: Text(
                                'Try again / click download multiple time if file is not downloading',
                                style: textStyle,
                                maxLines: 3,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
