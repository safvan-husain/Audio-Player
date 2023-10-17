import 'package:audio_player/viewes/playlist_pop_up_window/bloc/play_list_window_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayListDailogue extends StatelessWidget {
  final String trackName;
  const PlayListDailogue(this.trackName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: _buildPopUp(),
    );
  }

  Center _buildPopUp() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: 'm',
          child: Material(
            type: MaterialType.transparency,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: BlocBuilder<PlayListWindowBloc, PlayListWindowState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.all(15.r),
                  width: 200.w,
                  height: 110.h +
                      state.possiblePlaylists.length * 45.h +
                      ((state is InputTextState) ? 50.h : 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _createTitileAndCancelIcon(context),
                      ..._buildPlayListBoxes(state.possiblePlaylists,
                          state.currentPlayLists, context),
                      const Divider(),
                      if (state is InputTextState)
                        _buildForInput(context)
                      else
                        _createNewPlayListButton(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForInput(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 50.h,
      child: Column(
        children: [
          TextField(
            controller: controller,
            onSubmitted: (value) {
              if (controller.text.isNotEmpty) {
                context
                    .read<PlayListWindowBloc>()
                    .add(CreateNewPlayList(controller.text));
              }
              // Navigator.of(context).pop();
            },
            autofocus: true,
            decoration: const InputDecoration.collapsed(hintText: 'type here'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    context
                        .read<PlayListWindowBloc>()
                        .add(CreateNewPlayList(controller.text));
                  }
                  // Navigator.of(context).pop();
                },
                child: Text(
                  'submit',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildPlayListBoxes(
      List<String> possible, List<String> current, BuildContext context) {
    return possible
        .map(
          (e) => Row(
            children: [
              Checkbox(
                value: current.contains(e),
                onChanged: (val) {
                  if (val != null) {
                    if (val) {
                      context
                          .read<PlayListWindowBloc>()
                          .add(AddedToPlayList(trackName, e));
                    } else {
                      context
                          .read<PlayListWindowBloc>()
                          .add(RemoveFromPlayList(trackName, e));
                    }
                  }
                },
                checkColor: Theme.of(context).splashColor,
                activeColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              Text(
                e,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        )
        .toList();
  }

  GestureDetector _createNewPlayListButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PlayListWindowBloc>().add(ShowInputField());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.add,
            color: Colors.black,
          ),
          Flexible(
            child: Text(
              'create new playlist',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTitileAndCancelIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: Text(
            'Save Track to...',
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
