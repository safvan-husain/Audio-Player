import 'dart:developer';

import 'package:audio_player/viewes/drawer/bloc/drawer_bloc.dart';
import 'package:audio_player/viewes/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Preferences extends StatelessWidget {
  const Preferences({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<DrawerBloc, DrawerState>(
    //   builder: (context, state) {
    //     return GestureDetector(
    //       onTap: () {
    //         if (!state.isPreferencesExtended) {
    //           context.read<HomeBloc>().add(SwitchPreferencesExtendedness());
    //         }
    //       },
    //       child: Container(
    //         height: 30.h,
    //         width: MediaQuery.of(context).size.width,
    //         color: Theme.of(context).focusColor,
    //         child: Row(
    //           children: [
    //             const Text('Preferences'),
    //             if (state.isPreferencesExtended)
    //               InkWell(
    //                 onTap: () {
    //                   context
    //                       .read<HomeBloc>()
    //                       .add(SwitchPreferencesExtendedness());
    //                 },
    //                 child: const Icon(Icons.cancel_outlined),
    //               )
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    return const Placeholder();
  }
}
