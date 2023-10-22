import 'package:audio_player/common/theme.dart';
import 'package:audio_player/common/theme_services.dart';
import 'package:audio_player/database/data_base.dart';

import 'package:audio_player/viewes/audio/bloc/audio_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:audio_player/viewes/home/home_view.dart';
import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';

// void onDidReceiveNotificationResponse(
//     NotificationResponse notificationResponse) async {
//   final String? payload = notificationResponse.payload;
//   if (notificationResponse.payload != null) {
//     debugPrint('notification payload: $payload');
//   }
//   log('inside onDidReceiveNotificationResponse');
// }

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // AndroidFlutterLocalNotificationsPlugin? s =
  //     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>();
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  // const InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  // if (s != null) {
  //   s.requestNotificationsPermission();
  // }
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
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: MyTheme.light,
          darkTheme: MyTheme.dark,
          home: const HomeView(),
          themeMode: ThemeService().theme,
        );
      },
    );
  }
}
