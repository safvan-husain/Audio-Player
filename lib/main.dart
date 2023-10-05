import 'package:audio_player/common/theme.dart';
import 'package:audio_player/database/database_service.dart';
import 'package:audio_player/provider/audio_player_provider.dart';

import 'package:audio_player/utils/audio_name.dart';
import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DataBaseService dataBaseService = DataBaseService();
  await dataBaseService.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (ctx) => HomeBloc()),
        BlocProvider<AudioBloc>(create: (ctx) => AudioBloc()),
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
          home: HomeView(),
        );
      },
    );
  }
}
