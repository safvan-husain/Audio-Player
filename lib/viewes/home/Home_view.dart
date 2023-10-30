// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:audio_player/common/theme_services.dart';
import 'package:audio_player/services/audio_download_service.dart';
import 'package:audio_player/services/track_model.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_controll.dart';
import 'package:audio_player/viewes/home/widgets/audio_list.dart';
import 'package:audio_player/viewes/home/widgets/audio_search_tile.dart';
import 'package:audio_player/viewes/home/widgets/play_list_header.dart';
import 'package:audio_player/viewes/home/widgets/play_list_view.dart';
import 'package:audio_player/viewes/home/widgets/processing_download/pop_up_view.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/pop_up_route.dart';
import 'package:custom_search_bar/custom_search_bar.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVisible = false;
  bool _isPaused = false;
  bool _isLauched = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<HomeBloc>().add(RenderTracksFromDevice());

    ReceiveSharingIntent.getTextStream().listen((String value) async {
      Navigator.of(context).push(PopUpRoute(const DownloadDailogue()));
      AudioDownloadService().fetchData(
        value,
        (url) async {
          _isLauched = true;
          _launchInBrowser(Uri.parse(url));
        },
        () {
          Navigator.of(context).pop();
        },
      );
    }, onError: (err) {
      throw ("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        AudioDownloadService().fetchData(
          value,
          (url) async {
            _isLauched = true;
            _launchInBrowser(Uri.parse(url));
          },
          () {
            Navigator.of(context).pop();
          },
        );
      }
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isLauched) {
        Navigator.of(context).pop();
        _isLauched = false;
      }
      if (_isPaused && context.read<HomeBloc>().state.onHome) {
        //checking it was paused or not, because resumed called with init,
        //and only need to refresh home if not in a playlist view.
        //it result into calling twice RenderTracksFromDevice, and store tracks to storage twice.
        context.read<HomeBloc>().add(RenderTracksFromDevice());
      }
    } else if (state == AppLifecycleState.paused) {
      _isPaused = true;
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

//build calls when the audio position change
//attention need, fix.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        if (context.read<HomeBloc>().state.onHome) {
                          context
                              .read<HomeBloc>()
                              .add(RenderTracksFromDevice());
                        }
                      },
                      backgroundColor: Theme.of(context).cardColor,
                      color: Theme.of(context).splashColor,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            return switch (state) {
                              PlayListRendered(
                                trackList: var trackList,
                                playLists: var playLists,
                              ) =>
                                _buildPlayListPage(playLists, trackList),
                              _ => _buildDefaultpage(context, state)
                            };
                          },
                        ),
                      ),
                    ),
                    if (context.watch<AudioBloc>().state.tracks.isNotEmpty)
                      const AudioControl(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  WillPopScope _buildPlayListPage(
      List<String> playLists, List<Track> trackList) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeBloc>().add(RenderTracksFromApp());
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayListHeader(playListName: playLists[0]),
          AudioList(tracks: trackList)
        ],
      ),
    );
  }

  Column _buildDefaultpage(BuildContext context, HomeState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (state) {
          HomeInitial() => SizedBox(
              height: MediaQuery.of(context).size.height - 50.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          _ => Column(
              children: [
                const PlayListView(),
                // const PlayListHeader(),
                AudioList(tracks: state.trackList)
              ],
            ),
        },
      ],
    );
  }

  Container _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => ThemeService().switchTheme(),
            child:
                Icon(context.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return InkWell(
                onTap: () => showSearchForCustomiseSearchDelegate<Track>(
                  context: context,
                  delegate: SearchScreen(
                    items: state.trackList,
                    filter: (track) => [track.trackName, track.trackDetail],
                    itemBuilder: (t) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: AudioSearchTale(track: t),
                    ),
                  ),
                ),
                child: const Hero(tag: 'icon', child: Icon(Icons.search)),
              );
            },
          ),
        ],
      ),
    );
  }
}
