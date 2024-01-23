import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlands_ans2/base/base_page.dart';
import 'package:outlands_ans2/model/student_model.dart';
import 'package:outlands_ans2/model/teacher_model.dart';
import 'package:outlands_ans2/util/constants.dart';
import 'package:outlands_ans2/widget/button_widget.dart';

import '../database/db_helper.dart';

class TeacherPage extends BasePage {
  final int id;
  const TeacherPage({super.key, required this.id});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends BasePageState<TeacherPage> {

  late bool _isCheck = false;
  late final List<String> _listHelper = ['',''];
  late final List<TextEditingController> _listController = [TextEditingController(), TextEditingController()];

  @override
  String setTitle() => Constants.teacher;

  Widget _textFieldWidget(int i) {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _listController[i],
      style: Constants.textField22,
      cursorColor: Colors.blue,
      cursorWidth: 2.w,
      cursorRadius: Radius.circular(20.w),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        labelText: [Constants.course , Constants.name][i],
        labelStyle: Constants.textLabel,
        helperText: _listHelper[i],
        helperStyle: _listHelper[i] == Constants.verificationSuccess ? Constants.textHelperSuccess : Constants.textHelperFail,
        hoverColor: Colors.white,
        hintText: i == 0 ? Constants.courseHint : Constants.nameHint,
        hintStyle: Constants.textHint,
        border: Constants.textBorder,
        focusedBorder: Constants.textBorder,
        enabledBorder: Constants.textBorder,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[\u4e00-\u9fa5]')),
      ],
      onChanged: (value) {
        if (value.isNotEmpty) {
          _listController[i].text = value;
        }
      },
    );
  }

  Future<void> _check() async {
    if (_isCheck) {
      for (int i = 0; i < _listController.length; i++) {
        if (_listController[i].text.isEmpty) {
          _listHelper[i] = i == 0 ? Constants.course : Constants.name;
          if (i == 1) return;
        } else {
          _listHelper[i] = Constants.verificationSuccess;
        }
      }
      final TeacherModel teacherModel = await DBHelper.internal().selectByParam<TeacherModel>(Constants.listTeacher, Constants.id, [widget.id]);
      teacherModel.teacherName = _listController[1].text;
      teacherModel.courseId = teacherModel.teacherId?.replaceAll(RegExp('[T]'), 'C');
      teacherModel.courseName = _listController[0].text;
      // log('TeacherPage ${teacherModel.toMap()}');
      await DBHelper.internal().update<TeacherModel>(teacherModel.toMap(), Constants.id, [widget.id]);
      if (mounted) setState(() => _isCheck = false);
    } else {
      return;
    }
  }

  Future<void> _search() async {
    final StudentModel teacherModel = await DBHelper.internal().selectByParam<StudentModel>(Constants.listStudent, Constants.student, [widget.id]);
  }

  @override
  void dispose() {
    for (TextEditingController controller in _listController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget setBuild() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: _listController.asMap().entries.map((map) {
              return Column(
                children: [
                  _textFieldWidget(map.key),
                  SizedBox(height: 16.w),
                ],
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonWidget(text: '確定', tap: () {
                _isCheck = true;
                _check();
              }),
              ButtonWidget(text: '查詢選課學生', tap: _search),
            ],
          ),
        ],
      ),
    );
  }
}