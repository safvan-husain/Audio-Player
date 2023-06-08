// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_player/provider/current_index_provider.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<CurrentIndexProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomNavigationBar(
          opacity: 0.01,
          borderRadius: const Radius.circular(10),
          blurEffect: true,
          isFloating: true,
          iconSize: 30.0,
          elevation: 10,
          selectedColor: const Color(0xff040307),
          strokeColor: const Color(0x30040307),
          unSelectedColor: const Color(0xffacacac),
          backgroundColor: Colors.white,
          items: [
            CustomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.music_note_outlined),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.account_box_outlined),
            ),
          ],
          currentIndex: currentIndex.currentIndex,
          onTap: (index) => currentIndex.changeIndex(index),
        ),
      ),
    );
  }
}
