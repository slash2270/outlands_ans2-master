import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:outlands_ans2/base/base_page.dart';
import 'package:outlands_ans2/database/db_helper.dart';
import 'package:outlands_ans2/model/teacher_model.dart';
import 'package:outlands_ans2/util/constants.dart';
import 'package:outlands_ans2/widget/button_widget.dart';

import '../model/student_model.dart';
import 'custom/custom_toast.dart';

class MyHomePage extends BasePage {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends BasePageState<MyHomePage> {

  late List? _getSelectData;
  late String _selectRadio = '';
  late bool _isRegister = false, _isLogin = false, _isSecret = true;
  late final List<String> _listHelper = ['', ''], _listText = ['', ''];
  late final List<TextEditingController> _listController = [TextEditingController(), TextEditingController()];

  @override
  String setTitle() => Constants.home;

  Widget _radioWidget(int index, String name) {
    return Row(
      children: [
        Text(name, style: Constants.textLabel),
        Radio<String>(
            value: name,
            activeColor: Colors.blue,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            groupValue: _selectRadio,
            onChanged: (value) {
              _selectRadio = name;
              setState(() {});
            })
      ],
    );
  }

  Widget _textFieldWidget(int index) {
    return Stack(
      children: [
        TextField(
          controller: _listController[index],
          autofocus: true,
          keyboardType: TextInputType.text,
          style: index == 1 && _isSecret ? Constants.textFieldTransparent : Constants.textField22,
          cursorColor: Colors.blue,
          cursorWidth: 2.w,
          cursorRadius: Radius.circular(20.w),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: [Constants.account,Constants.password][index],
            labelStyle: Constants.textLabel,
            helperText: _listHelper[index],
            helperStyle: _listHelper[index] == Constants.verificationSuccess ? Constants.textHelperSuccess : Constants.textHelperFail,
            hoverColor: Colors.white,
            hintText: [Constants.accountHint,Constants.passwordHint][index],
            hintStyle: Constants.textHint,
            suffix: Visibility(
              visible: index == 0 ? false : true,
              child: IconButton(
                icon: Icon(_isSecret ? Icons.remove_red_eye : Icons.remove_red_eye_outlined, color: Colors.grey),
                onPressed: () {
                  _isSecret = !_isSecret;
                  if (_isSecret) {
                    _listText[1] = "";
                    List.generate(_listController[1].text.length, (index) => _listText[1] += "*");
                  }
                  setState(() {});
                },
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            focusedBorder:Constants.textBorder,
            border: Constants.textBorder,
            enabledBorder: Constants.textBorder,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(index == 0 ? RegExp("[T]|[S]|[0-9]") : RegExp("[a-zA-Z]|[0-9]|[*]")),
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              _listController[index].text = value;
              if (index == 1) {
                if (_isSecret) {
                  _listText[index] = "";
                  List.generate(value.length, (index) =>  _listText[1] += "*");
                  setState(() {});
                }
              } else {
                return;
              }
            } else {
              _listHelper[index] = '';
              _listController[index].text = '';
              _listText[index] = '';
              setState(() {});
            }
          },
        ),
        Positioned(
          top: 15,
          left: 5,
          bottom: 0,
          child: Text(_listText[index], style: _isSecret && index == 1 ? Constants.textField20 : Constants.textFieldTransparent),
        )
      ],
    );
  }

  Future<void> _check() async {
    for (int i = 0; i < _listController.length; i++) {
      if (_isRegister || _isLogin) {
        if (_selectRadio.isEmpty) {
          _listHelper[i] = '請選擇身份';
        } else {
          if (_listController[i].text.length < 6 || _listController[i].text.isEmpty) {
            _listHelper[i] = '請輸入6位英文數字';
          } else {
            _regMatch(i);
            if (_isLogin) _checkSQL(i);
          }
        }
      }
      // log('text:${_listText[i]}');
    }
    if (mounted) setState(() {});
    // if (_listHelper.where((helper) => helper == '驗證成功').toList().length != 2) return;
    _getSelectData = await _selectData();
    log('getSelectData: $_getSelectData, length: ${_getSelectData?.length}');
    if (_isRegister) {
      if (_getSelectData?.length == 99999) {
        if (mounted) Toast.toast(context, msg: '帳號數量已滿, 請聯絡客服人員, 謝謝', showTime: 2000, position: ToastPosition.center);
        _isRegister = false;
        _isLogin = false;
        return;
      }
      // final String account = Constants.setAccount(getSelectData.length + 1);
      await DBHelper.internal().insert(
          _selectRadio == Constants.teacher
          ? Constants.teacher
          : _selectRadio == Constants.student
          ? Constants.student
          : '',
        _selectRadio == Constants.teacher
            ? [TeacherModel(id: _getSelectData?.length ?? 1, teacherId: _listController[0].text, teacherPassword: _listController[1].text, teacherName: '', courseId: '', courseName: '')]
            : _selectRadio == Constants.student
            ? [StudentModel(id: _getSelectData?.length ?? 1, studentId: _listController[0].text, studentPassword: _listController[1].text, studentName: '', courseId: '')]
            : [],
      );
      final String identify =
      _selectRadio == Constants.teacher
          ? 'T'
          : _selectRadio == Constants.student
          ? 'S'
          : '';
      if (mounted) Toast.toast(context, msg: '註冊成功\n帳號: $identify${_listController[0].text}\n請登入帳號編輯資料', showTime: 2000, position: ToastPosition.center);
      _isRegister = false;
      _isLogin = false;
      return;
    }
    if (_isLogin) {
      _isRegister = false;
      _isLogin = false;
      if (mounted) context.push('/${_selectRadio == Constants.teacher ? Constants.teacher : _selectRadio == Constants.student ? Constants.student : ""}', extra: _getSelectData?.length ?? 1);
    }
  }

  void _regMatch(int i) {
    bool matched;
    String text = '';
    RegExp exp = RegExp('');
    if (i == 0) {
      if (_selectRadio == Constants.teacher) {
        text = 'T';
        exp = RegExp(r"(?![T]+$)(?![0-9]{5}$)");
      }
      if (_selectRadio == Constants.student) {
        text = 'S';
        exp = RegExp(r"(?![S]+$)(?![0-9]{5}$)");
      }
      matched = exp.hasMatch(_listController[i].text);
      setState(() => _listHelper[i] = matched ? Constants.verificationSuccess : '請輸入$text + 5位數字');
    }
    if (i == 1) {
      exp = RegExp(r"[A-za-z]");
      matched = exp.hasMatch(_listController[i].text);
      if (!matched) {
        setState(() => _listHelper[i] = Constants.passwordHint);
        return;
      }
      exp = RegExp(r"[0-9]");
      matched = exp.hasMatch(_listController[i].text);
      setState(() => _listHelper[i] = matched ? Constants.verificationSuccess : Constants.passwordHint);
    }
  }

 Future<void> _checkSQL(int i) async {
    dynamic param;
    if (_selectRadio == Constants.teacher) {
      param = await DBHelper.internal().selectByParam<TeacherModel>(
          Constants.listTeacher,
          i == 0 ? Constants.teacherId : Constants.teacherPassword,
          [_listController[i].text]
      );
    }
    if (_selectRadio == Constants.student) {
      param = await DBHelper.internal().selectByParam<StudentModel>(
          Constants.listStudent,
          i == 0 ? Constants.studentId : Constants.studentPassword,
          [_listController[i].text]
      );
    }
    // log('checkSQL param: $param');
    if (param == null) {
      _listHelper[i] = '無此${i == 0 ? '帳號' : '密碼'}, 請洽客服或網路管理員, 謝謝.';
      return;
    }
  }

  Future<List> _selectData() async {
    List getListData = [];
    if (_selectRadio == Constants.teacher) getListData = await DBHelper.internal().select<TeacherModel>();
    if (_selectRadio == Constants.student) getListData = await DBHelper.internal().select<StudentModel>();
    // final List<String> selectData = [];
    // for (dynamic data in getListData) {
    //   switch(_selectRadio){
    //     case Constants.teacher:
    //       final TeacherModel model = data as TeacherModel;
    //       selectData.add('${model.id}\n${model.teacherId}\n${model.teacherPassword}\n${model.teacherName}\n${model.courseId}\n${model.courseName}');
    //       break;
    //     case Constants.student:
    //       final StudentModel model = data as StudentModel;
    //       selectData.add('${model.id}\n${model.studentId}\n${model.studentPassword}\n${model.studentName}\n${model.courseId}');
    //       break;
    //   }
    // }
    // log('Home selectData: $selectData');
    return getListData;
  }

  @override
  void dispose() {
    super.dispose();
    for (TextEditingController c in _listController) {
      c.dispose();
    }
  }

  @override
  Widget setBuild() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Constants.teacher, Constants.student].asMap().entries.map((e) => _radioWidget(e.key, e.value)).toList(),
            ),
            SizedBox(height: 20.w),
            Column(
              children: _listController.asMap().entries.map((e) => Column(
                children: [
                  _textFieldWidget(e.key),
                  SizedBox(height: 16.w),
                ],
              )).toList(),
            ),
            SizedBox(height: 10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Constants.signUp, Constants.login].asMap().entries.map((e) =>
                   ButtonWidget(text: e.value, tap: () {
                    if (e.key == 0) _isRegister = true;
                    if (e.key == 1) _isLogin = true;
                    _check();
                }),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}