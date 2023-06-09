import 'dart:developer';

import 'package:audio_player/provider/audio_player_provider.dart';
import 'package:audio_player/provider/current_audio.dart';
import 'package:audio_player/provider/current_index_provider.dart';
import 'package:audio_player/utils/bottom_nav_bar.dart';
import 'package:audio_player/viewes/home/home_view.dart';
import 'package:audio_player/viewes/home/widgets/progress_bar.dart';
import 'package:audio_player/viewes/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CurrentIndexProvider()),
      ChangeNotifierProvider(create: (_) => CurrentAudioProvider()),
      ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _pages = [
    const HomeView(),
    const SearchView(),
    const Center(
      child: Text('music'),
    ),
    const Center(
      child: Text('account'),
    ),
    const Center(
      child: Text('m'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _pages
                .elementAt(context.watch<CurrentIndexProvider>().currentIndex),
            if (context.watch<AudioPlayerProvider>().length() > 0)
              audios(context)
          ],
        ),
        bottomNavigationBar: const BottomNav());
  }

  Positioned audios(BuildContext context) {
    log(context.watch<AudioPlayerProvider>().length().toString());
    return Positioned(
      bottom: 80,
      left: 1,
      right: 1,
      child: Column(
        children: context
            .watch<AudioPlayerProvider>()
            .audioPlayer
            .entries
            .map((entry) => AudioControl(
                  player: entry.value,
                  audioPath: entry.key,
                ))
            .toList(),
      ),
    );
  }
}
