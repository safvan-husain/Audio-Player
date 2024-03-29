import 'package:audio_player/theme/theme.dart';
import 'package:audio_player/theme/get_storage.dart';
import 'package:audio_player/database/data_base.dart';
import 'package:audio_player/services/audio_player_services.dart';

import 'package:audio_player/bloc/audio bloc/audio_bloc.dart';
import 'package:audio_player/bloc/home bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/home_view.dart';
import 'package:audio_player/bloc/playlist%20bloc/play_list_window_bloc.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';

late AudioPlayerHandler _audioHandler;
void main() async {
  await GetStorage.init();
  FastStorage().showGuide();
  WidgetsFlutterBinding.ensureInitialized();
  _audioHandler = await AudioService.init<AudioPlayerHandler>(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  MyDataBase dataBaseService = MyDataBase();
  late HomeBloc homeBloc;
  late AudioBloc audioBloc;
  await dataBaseService.init();
  homeBloc = HomeBloc();
  audioBloc = AudioBloc(homeBloc, _audioHandler);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (ctx) => homeBloc),
        BlocProvider<AudioBloc>(create: (ctx) => audioBloc),
        BlocProvider<PlayListWindowBloc>(
            create: (ctx) => PlayListWindowBloc(homeBloc)),
        BlocProvider<FastStorage>(create: (ctx) => FastStorage()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme.light,
          darkTheme: MyTheme.dark,
          home: const HomeView(),
          themeMode: FastStorage().theme,
        );
      },
    );
  }
}
