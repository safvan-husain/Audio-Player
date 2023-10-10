import 'package:audio_player/viewes/drawer/drawer_widgets/play_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

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
            const PlayListView(),
            SizedBox(height: 10.h),
            // Preferences(),
          ],
        ),
      ),
    );
  }
}
