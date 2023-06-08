import 'package:audio_player/provider/current_index_provider.dart';
import 'package:audio_player/utils/bottom_nav_bar.dart';
import 'package:audio_player/viewes/home/Home_view.dart';
import 'package:audio_player/viewes/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => CurrentIndexProvider())],
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
  final List<Widget> _pages = const [
    HomeView(),
    SearchView(),
    Center(
      child: Text('music'),
    ),
    Center(
      child: Text('account'),
    ),
    Center(
      child: Text('m'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: _pages
            .elementAt(context.watch<CurrentIndexProvider>().currentIndex),
        bottomNavigationBar: const BottomNav());
  }
}
