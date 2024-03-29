import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function tap;
  const ButtonWidget({super.key, required this.text, required this.tap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          border: Border.all(width: 1.w),
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
            child: Text(text, maxLines: 1, style: Constants.textButton),
          ),
          onTap: () => tap(),
        ),
      )
    );
  }
}