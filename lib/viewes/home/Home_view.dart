import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:audio_player/services/result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:audio_player/common/icon_box.dart';
import 'package:audio_player/services/audio_download_service.dart';
import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/widgets/audio_controll.dart';
import 'package:audio_player/viewes/home/widgets/audio_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_downloader/youtube_downloader.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _intentDataStreamSubscription;
  late List<SharedMediaFile> _sharedFiles;
  YoutubeDownloader youtubeDownloader = YoutubeDownloader();
  static const platform = MethodChannel('example.com/channel');

  Future<void> _generateRandomNumber() async {
    late String _jsonList_tracks;
    if (await ensurePermissionGranted()) {
      try {
        _jsonList_tracks = await platform.invokeMethod('getRandomNumber');
      } on PlatformException catch (e) {
        print(e);
        _jsonList_tracks = '';
      }
      List _trackList = jsonDecode(_jsonList_tracks);
      if (_trackList.isNotEmpty) {
        for (var element in _trackList) {
          print(element);
        }
      }
    } else {
      throw ('Permission denied');
    }
  }

  @override
  void initState() {
    // _getMp3Files();
    _generateRandomNumber();
    context.read<HomeBloc>().add(RenderTracksFromDevice());
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
        _sharedFiles = value;
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
      });
    });
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) async {
      log(value);

      AudioDownloadService().fetchData(value, (url) async {
        _launchInBrowser(Uri.parse(url));
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null)
        log(value);
      else
        print('vslue nul');
    });
    super.initState();
    log('calling init on home view');
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Future<List<String>> _getMp3Files() async {
  //   final Directory? directory = await getExternalStorageDirectory();

  //   if (await ensurePermissionGranted()) {
  //     final List<String> mp3Files = [];
  //     if (directory == null) {
  //       throw ('directry is null');
  //     }
  //     if (directory.existsSync()) {
  //       List<FileSystemEntity> files = directory.listSync(recursive: true);
  //       if (files.isEmpty) {
  //         print('Directory is empty - ${directory.path}');
  //       } else {
  //         print('Found ${files.length} files');
  //       }
  //     } else {
  //       throw ('Directory does not exist');
  //     }
  //     List<FileSystemEntity> files = directory.listSync(recursive: true);
  //     log('all files length: ${files.length}');
  //     for (FileSystemEntity file in files) {
  //       print(file.path);
  //       if (file.path.endsWith('.mp3')) {
  //         mp3Files.add(file.path);
  //       }
  //     }
  //     log('mp3 files should be next ${mp3Files.length}');
  //     print(mp3Files);
  //     return mp3Files;
  //   } else {
  //     throw ('permission denied');
  //   }
  // }

  Future<bool> ensurePermissionGranted() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
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
                        // _scaffoldKey.currentState!.openDrawer();
                        _generateRandomNumber();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getFilePath();
          context.read<HomeBloc>().add(RenderTracksFromDevice());
        },
        mini: true,
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
