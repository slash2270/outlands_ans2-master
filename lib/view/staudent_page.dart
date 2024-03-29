import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlands_ans2/util/constants.dart';
import 'package:outlands_ans2/view/no_data_view.dart';

import '../base/base_page.dart';
import '../database/db_helper.dart';
import '../model/student_model.dart';
import '../model/teacher_model.dart';
import '../widget/button_widget.dart';
import 'custom/custom_future_builder.dart';
import 'custom/custom_toast.dart';

class StudentPage extends BasePage {
  final StudentModel model;
  const StudentPage({super.key, required this.model});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends BasePageState<StudentPage> {

  Future<List<TeacherModel>>? _future;
  late List<TeacherModel> _listTeacherModel;
  late bool _isUpdate = false;
  late String _helper = '';
  late int _selectIndex = -1;
  late final TextEditingController _controller = TextEditingController();

  @override
  String setTitle() => Constants.student;

  @override
  void initState() {
    if (widget.model.id != null) {
      _controller.text = widget.model.studentName!;
    }
    super.initState();
  }

  Widget _textFieldWidget() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _controller,
      style: Constants.textField22,
      cursorColor: Colors.blue,
      cursorWidth: 2.w,
      cursorRadius: Radius.circular(20.w),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        labelText: Constants.name,
        labelStyle: Constants.textLabel,
        helperText: _helper,
        helperStyle: _helper == Constants.verificationSuccess ? Constants.textHelperSuccess : Constants.textHelperFail,
        hoverColor: Colors.white,
        hintText: Constants.nameHint,
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
          _controller.text = value;
        }
      },
    );
  }

  void _checkAndUpdate({bool isChoice = false}) {
    if (_isUpdate) {
      log('StudentPage id: ${widget.model.id}');
      final StudentModel studentModel = widget.model;
      if (studentModel.studentName?.isEmpty == true) {
        if (_controller.text.isEmpty) {
          _helper = Constants.nameHint;
          return;
        } else {
          _helper = Constants.verificationSuccess;
          studentModel.studentName = _controller.text;
          _update(studentModel, isChoice: isChoice);
        }
      } else {
        _controller.text = studentModel.studentName!;
      }
      if (isChoice) {
        studentModel.courseId = _listTeacherModel[_selectIndex].courseId;
        _update(studentModel, isChoice: isChoice);
      }
    } else {
      return;
    }
  }

  Future<void> _update(StudentModel model, {required bool isChoice}) async {
    await DBHelper.internal().update<StudentModel>(model.toMap(), Constants.id, [widget.model.id]);
    if (mounted) Toast.toast(context, msg: '${isChoice ? '選擇' : '更新'}成功', showTime: 2000, position: ToastPosition.center);
    _isUpdate = false;
  }

  void _search() {
    _future = DBHelper.internal().select<TeacherModel>();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget setBuild() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.w),
        child: Column(
          children: [
            Column(
              children: [
                _textFieldWidget(),
                SizedBox(height: 10.w),
                ButtonWidget(text: '更新個人資料',
                    tap: () {
                      setState(() => _isUpdate = true);
                      _checkAndUpdate();
                    }),
              ],
            ),
            SizedBox(height: 50.w),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(text: '查詢講師和課程', tap: _search),
                    ButtonWidget(text: '選擇課程',
                        tap: () {
                          setState(() => _isUpdate = true);
                          _checkAndUpdate(isChoice: true);
                        }),
                  ],
                ),
                SizedBox(height: 20.w),
                _future == null
                    ? const SizedBox.shrink()
                    : CustomFutureBuilder(
                    key: ValueKey(_future),
                    getData: () => _future!,
                    widget: (data) {
                      _listTeacherModel = data ?? [];
                      return data == null || data.isEmpty
                          ? const NoDataView()
                          : ListView.separated(
                        key: ValueKey(data),
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        cacheExtent: 80.w,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.all(Radius.circular(10.w))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('${data[index].teacherName ?? '無老師姓名'}  ${data[index].courseName ?? '無課程'}',
                                      style: Constants.textField20, textAlign: TextAlign.center),
                                ),
                                Radio(
                                    value: index,
                                    activeColor: Colors.blue,
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    groupValue: _selectIndex,
                                    onChanged: (value) {
                                      _selectIndex = index;
                                      setState(() {});
                                    }
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(height: 16.w),
                    );
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}