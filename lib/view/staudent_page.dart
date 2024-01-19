import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlands_ans2/util/constants.dart';

import '../base/base_page.dart';

class StudentPage extends BasePage {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends BasePageState<StudentPage> {

  @override
  String setTitle() => Constants.student;

  @override
  Widget setBuild() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [

              ],
            )
          ],
        ),
      ),
    );
  }

}