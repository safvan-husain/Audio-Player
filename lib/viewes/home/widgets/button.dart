// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onTap;
  final bool isOn;
  // final bool value;
  const Button({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isOn,
    // required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 15,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: isOn
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).cardColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).focusColor,
                ),
                Text(
                  label,
                  style: GoogleFonts.russoOne(
                      color: Theme.of(context).focusColor,
                      textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 16.r)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
