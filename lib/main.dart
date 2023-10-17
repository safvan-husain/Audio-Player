import 'package:audio_player/common/theme.dart';
import 'package:audio_player/database/data_base.dart';
import 'package:audio_player/database/database_service.dart';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/drawer/bloc/drawer_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/home_view.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyDataBase dataBaseService = MyDataBase();
  await dataBaseService.init();
  HomeBloc homeBloc = HomeBloc();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (ctx) => homeBloc),
        BlocProvider<AudioBloc>(create: (ctx) => AudioBloc(homeBloc)),
        BlocProvider<PlayListWindowBloc>(
            create: (ctx) => PlayListWindowBloc(homeBloc)),
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: MyTheme.light,
          darkTheme: MyTheme.dark,
          home: const HomeView(),
        );
      },
    );
  }
}
