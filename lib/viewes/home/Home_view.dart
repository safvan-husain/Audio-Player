// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:audio_player/common/icon_box.dart';
import 'package:audio_player/services/audio_download_service.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_controll.dart';
import 'package:audio_player/viewes/home/widgets/audio_list.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<HomeBloc>().add(RenderTracksFromDevice());

    ReceiveSharingIntent.getTextStream().listen((String value) async {
      log(value);

      AudioDownloadService().fetchData(value, (url) async {
        _launchInBrowser(Uri.parse(url));
      });
    }, onError: (err) {
      throw ("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        AudioDownloadService().fetchData(value, (url) async {
          _launchInBrowser(Uri.parse(url));
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      context.read<HomeBloc>().add(RenderTracksFromDevice());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.abc),
                      ),
                    ),
                    const InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.abc),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (ctx, state) {
                          return switch (state) {
                            HomeInitial() => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            HomeLoaded(trackList: var trackList) =>
                              AudioList(tracks: trackList),
                          };
                        },
                      ),
                    ),
                    if (context.watch<AudioBloc>().state.controller != null)
                      const Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Hero(
                          tag: 'heri',
                          child: AudioControl(),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawerEdgeDragWidth: 100.0,
      drawer: Drawer(
        child: ListView(children: [
          const Text('hi'),
        ]),
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
