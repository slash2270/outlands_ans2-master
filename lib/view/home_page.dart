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
    dynamic model;
    for (int i = 0; i < _listController.length; i++) {
      if (_isRegister || _isLogin) {
        if (_selectRadio.isEmpty) {
          _listHelper[i] = '請選擇身份';
        } else {
          if (_listController[i].text.length < 6 || _listController[i].text.isEmpty) {
            _listHelper[i] = '請輸入6位英文數字';
          } else {
            _regMatch(i);
            if (_isLogin) {
              model = await _checkSQL(i);
            }
          }
        }
      }
      log('text: ${_listText[i]} controller: ${_listController[i].text}');
    }
    if (mounted) setState(() {});
    _getSelectData = await _selectData();
    log('helper: $_listHelper getSelectData: $_getSelectData length: ${_getSelectData?.length}');
    if (_isRegister) {
      _isRegister = false;
      _isLogin = false;
      if (_getSelectData?.length == 99999) {
        if (mounted) Toast.toast(context, msg: '帳號數量已滿, 請聯絡客服人員, 謝謝', showTime: 2000, position: ToastPosition.bottom);
        return;
      }
      final int number = int.parse(_listController[0].text.substring(1, 6));
      if (_getSelectData!.where((element) => element.id == number).toList().isNotEmpty) {
        if (mounted) Toast.toast(context, msg: '此帳號已註冊, 請換個號碼, 謝謝', showTime: 2000, position: ToastPosition.bottom);
        return;
      }
      if (_listHelper.where((element) => element != Constants.verificationSuccess).toList().length == _listHelper.length) {
        if (mounted) Toast.toast(context, msg: '格式不正確', showTime: 2000, position: ToastPosition.bottom);
        return;
      }
      final int id = _getSelectData?.isEmpty == true ? 1 : int.parse(_listController[0].text.substring(1, 6));
      log('SQL id $id');
      await DBHelper.internal().insert(_selectRadio, _setInsert(id));
      if (mounted) Toast.toast(context, msg: '註冊成功\n帳號: ${_listController[0].text}\n請登入帳號編輯資料', showTime: 2000, position: ToastPosition.bottom);
      return;
    }
    if (_isLogin) {
      _isRegister = false;
      _isLogin = false;
      if (_getSelectData == null || _getSelectData?.isEmpty == true) {
        if (mounted) Toast.toast(context, msg: '未註冊帳號', showTime: 2000, position: ToastPosition.bottom);
        return;
      }
      if (_listHelper.where((element) => element != Constants.verificationSuccess).toList().isNotEmpty) {
        if (mounted) Toast.toast(context, msg: '格式不正確', showTime: 2000, position: ToastPosition.bottom);
        return;
      }
      if (mounted) context.push('/$_selectRadio', extra: model);
    }
  }

  void _regMatch(int i) {
    bool matched;
    String text = '';
    RegExp exp = RegExp('');
    switch(i) {
      case 0:
        switch(_selectRadio) {
          case Constants.teacher:
            text = 'T';
            exp = RegExp(r"(?![T]+$)(?![0-9]{5}$)");
            break;
          case Constants.student:
            text = 'S';
            exp = RegExp(r"(?![S]+$)(?![0-9]{5}$)");
            break;
        }
        break;
      case 1:
        exp = RegExp(r"[A-za-z0-9]");
        break;
    }
    matched = exp.hasMatch(_listController[i].text);
    setState(() => _listHelper[i] = matched ? Constants.verificationSuccess : i == 0 ? '請輸入$text + 5位數字' : Constants.passwordHint);
  }

 Future<dynamic> _checkSQL(int i) async {
    switch(_selectRadio) {
      case Constants.teacher:
        final model = await DBHelper.internal().selectByParam<TeacherModel>(
            Constants.listTeacher,
            Constants.teacherId,
            [_listController[0].text]
        );
        _noDataSQL(model, i, i == 0 ? model.teacherId != _listController[0].text : i == 1 ? model.teacherPassword != _listController[1].text : true);
        return model;
      case Constants.student:
        final model = await DBHelper.internal().selectByParam<StudentModel>(
            Constants.listStudent,
            Constants.studentId,
            [_listController[0].text]
        );
        _noDataSQL(model, i, i == 0 ? model.studentId != _listController[0].text : i == 1 ? model.studentPassword != _listController[1].text : true);
        return model;
    }
  }

  void _noDataSQL(dynamic model, int i, bool isText) {
    if (model == null) {
      _listHelper[i] = '無資料${Constants.dataError}';
      return;
    }
    _listHelper[i] = isText ? '無此${i == 0 ? '帳號': '密碼'}${Constants.dataError}' : Constants.verificationSuccess;
  }

  Future<List> _selectData() async {
    switch(_selectRadio) {
      case Constants.teacher:
        return await DBHelper.internal().select<TeacherModel>();
      case Constants.student:
        return await DBHelper.internal().select<StudentModel>();
      default:
        return [];
    }
  }

  List _setInsert(int id) {
    switch(_selectRadio) {
      case Constants.teacher:
        return [TeacherModel(id: id, teacherId: _listController[0].text, teacherPassword: _listController[1].text, teacherName: '', courseId: '', courseName: '')];
      case Constants.student:
        return [StudentModel(id: id, studentId: _listController[0].text, studentPassword: _listController[1].text, studentName: '', courseId: '')];
      default:
        return [];
    }
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