import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlands_ans2/base/base_page.dart';
import 'package:outlands_ans2/util/constants.dart';
import 'package:outlands_ans2/widget/button_widget.dart';

class TeacherPage extends BasePage {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends BasePageState<TeacherPage> {

  String _courseHelper = '';
  late final TextEditingController _courseController = TextEditingController();

  @override
  String setTitle() => Constants.teacher;

  Widget _textFieldCourseWidget() {
    return TextField(
      controller: _courseController,
      autofocus: true,
      keyboardType: TextInputType.text,
      style: Constants.textField22,
      cursorColor: Colors.blue,
      cursorWidth: 2.w,
      cursorRadius: Radius.circular(20.w),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: Constants.course,
        labelStyle: Constants.textLabel,
        helperText: _courseHelper,
        helperStyle: _courseHelper == '驗證成功' ? Constants.textHelperSuccess : Constants.textHelperFail,
        hoverColor: Colors.white,
        hintText: Constants.courseHint,
        hintStyle: Constants.textHint,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        focusedBorder: Constants.textBorder,
        border: Constants.textBorder,
        enabledBorder: Constants.textBorder,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow('[\u4e00-\u9fa5]'),
      ],
      onChanged: (value) {
        if (value.isNotEmpty) {
          _courseController.text = value;
        }
      },
    );
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget setBuild() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Row(
            children: [
              _textFieldCourseWidget(),
              ButtonWidget(text: '確定', tap: (){

              }),
            ],
          )
        ],
      ),
    );
  }

}