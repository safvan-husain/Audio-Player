// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:audio_player/viewes/home/widgets/play_list_view.dart';

class MyDrawer extends StatelessWidget {
  final void Function() closeDrawer;
  const MyDrawer({
    Key? key,
    required this.closeDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            PlayListView(),
            SizedBox(height: 10.h),
            // Preferences(),
          ],
        ),
      ),
    );
  }
}
