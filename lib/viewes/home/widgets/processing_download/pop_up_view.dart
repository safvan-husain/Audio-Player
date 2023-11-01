import 'package:audio_player/services/audio_download_service.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadDailogue extends StatefulWidget {
  final String value;
  const DownloadDailogue(this.value, {super.key});

  @override
  State<DownloadDailogue> createState() => _DownloadDailogueState();
}

class _DownloadDailogueState extends State<DownloadDailogue> {
  bool isDownloable = false;
  late String url;
  @override
  void initState() {
    AudioDownloadService().fetchData(
      ytId: widget.value,
      onMp3Generated: (uri) async {
        url = uri;
        setState(() {
          isDownloable = true;
        });
      },
      onFailure: (message) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to convert!')));
      },
    );
    super.initState();
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

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
                    ),
                    SizedBox(height: 7.h),
                    Material(
                      elevation: isDownloable ? 3 : 0,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isDownloable
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).cardColor),
                        child: () {
                          if (isDownloable) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  isDownloable = false;
                                });
                                await _launchInBrowser(url);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Center(
                                  child: Text(
                                'Download from web',
                                style: GoogleFonts.russoOne(
                                    color: Theme.of(context).cardColor,
                                    textStyle: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14.r)),
                              )),
                            );
                          }
                          return SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).splashColor,
                              ));
                        }(),
                      ),
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
