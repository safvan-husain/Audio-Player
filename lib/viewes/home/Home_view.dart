// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:audio_player/common/icon_box.dart';
import 'package:audio_player/services/audio_download_service.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/drawer/bloc/drawer_bloc.dart';
import 'package:audio_player/viewes/drawer/drawer.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_controll.dart';
import 'package:audio_player/viewes/home/widgets/audio_list.dart';
import 'package:audio_player/viewes/home/widgets/play_list_header.dart';
import 'package:audio_player/viewes/home/widgets/processing_download/pop_up_view.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/pop_up_route.dart';
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
      if (_isPaused && context.read<HomeBloc>().state.playList == "All") {
        //checking it was paused or not, because resumed called with init,
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
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              context.read<DrawerBloc>().add(ListPlayLists());
              _scaffoldKey.currentState?.openDrawer();
            }
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: const Icon(Icons.horizontal_split),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(PopUpRoute(const DownloadDailogue()));
                              },
                              child: const Icon(Icons.search),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (ctx, state) {
                          return switch (state) {
                            HomeInitial() => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            _ => Column(
                                children: [
                                  if (state.playList != "All")
                                    const PlayListHeader(),
                                  AudioList(tracks: state.trackList)
                                ],
                              ),
                          };
                        },
                      ),
                    ],
                  ),
                ),
                if (context.watch<AudioBloc>().state.controller != null)
                  const AudioControl()
              ],
            ),
          ),
        ),
      ),
      drawerEdgeDragWidth: 0.0,
      drawer: MyDrawer(
        closeDrawer: () => _scaffoldKey.currentState!.closeDrawer(),
      ),
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
