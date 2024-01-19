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

  String _selectRadio = '';
  late List getSelectData;
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
            helperStyle: _listHelper[index] == '驗證成功' ? Constants.textHelperSuccess : Constants.textHelperFail,
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
    for (int i = 0; i < _listHelper.length; i++) {
      if (_isRegister || _isLogin) {
        if (_selectRadio.isEmpty) {
          _listHelper[i] = '請選擇身份';
        } else {
          if (_isRegister || _isLogin) {
            if (_listController[i].text.length < 6 || _listController[i].text.isEmpty) {
              _listHelper[i] = '請輸入6位英文數字';
            } else {
              i == 0 ? _checkAccount() : _checkPassword();
              if (_isLogin) _checkSQL(i);
            }
          }
        }
      }
      // log('text:${_listText[i]}');
    }
    if (mounted) setState(() {});
    if (_isRegister && _listHelper[1] == '驗證成功') {
      _isRegister = false;
      _isLogin = false;
      getSelectData = await _selectData();
      if (getSelectData.length == 99999) {
        if (mounted) Toast.toast(context, msg: '帳號數量已滿, 請聯絡客服人員, 謝謝', position: ToastPosition.center);
        return;
      }
      final int id = getSelectData.length + 1;
      final String account = Constants.setAccount(getSelectData.length + 1);
      await DBHelper.internal().insert(
          _selectRadio == Constants.teacher
          ? Constants.teacher
          : _selectRadio == Constants.student
          ? Constants.student
          : '',
        _selectRadio == Constants.teacher
            ? [TeacherModel(id, account, _listController[1].text, '', '', '')]
            : _selectRadio == Constants.student
            ? [StudentModel(id, account, _listController[1].text, '', '')]
            : [],
      );
      final String identify = _selectRadio == Constants.teacher
          ? 'T'
          : _selectRadio == Constants.student
          ? 'S'
          : '';
      if (mounted) Toast.toast(context, msg: '註冊成功\n帳號: $identify$account\n請登入帳號編輯資料', position: ToastPosition.center);
      return;
    }
    if (_isLogin && _listHelper.where((helper) => helper == '驗證成功').toList().length == 2) {
      _isRegister = false;
      _isLogin = false;
      if (mounted) context.push('/${_selectRadio == Constants.teacher ? Constants.teacher : _selectRadio == Constants.student ? Constants.student : ""}');
    }
  }

  void _checkAccount() {
    String text = '';
    RegExp exp = RegExp('');
    if (_selectRadio == Constants.teacher) {
      text = 'T';
      exp = RegExp(r"(?![T]+$)(?![0-9]{5}$)");
    }
    if (_selectRadio == Constants.student) {
      text = 'S';
      exp = RegExp(r"(?![S]+$)(?![0-9]{5}$)");
    }
    final bool matched = exp.hasMatch(_listController[0].text);
    if (!matched) _listHelper[0] = '請輸入$text + 5位數字';
    return;
  }

  void _checkPassword() {
    RegExp exp = RegExp(r"[A-za-z]");
    bool matched = exp.hasMatch(_listController[1].text);
    if (!matched) {
      setState(() => _listHelper[1] = Constants.passwordHint);
      return;
    }
    exp = RegExp(r"[0-9]");
    matched = exp.hasMatch(_listController[1].text);
    if (!matched) _listHelper[1] = Constants.passwordHint;
    return;
  }

 Future<void> _checkSQL<T>(int i) async {
    dynamic param;
    getSelectData = await _selectData();
    if (_selectRadio == Constants.teacher) {
      param = await DBHelper.internal().selectByParam<TeacherModel?>(
          Constants.teacher,
          Constants.listTeacher,
          '${i == 0 ? Constants.teacherId : Constants.teacherPassword} = ?',
          getSelectData
      );
    }
    if (_selectRadio == Constants.student) {
      param = await DBHelper.internal().selectByParam<StudentModel?>(
          Constants.student,
          Constants.listStudent,
          '${i == 0 ? Constants.studentId : Constants.studentPassword} = ?',
          getSelectData
      );
    }
    if (param == null) {
      _listHelper[i] = '無此${i == 0 ? '帳號' : '密碼'}, 請洽客服或網路管理員, 謝謝.';
      return;
    }
  }

  Future<List> _selectData() async {
    final getListData = await DBHelper.internal().select(
        _selectRadio == Constants.teacher
            ? Constants.teacher
            : _selectRadio == Constants.student
            ? Constants.student
            : '',
        _selectRadio == Constants.teacher
            ? Constants.listTeacher
            : _selectRadio == Constants.student
            ? Constants.listStudent
            : []
    );
    List<String> selectData = [];
    for (dynamic data in getListData) {
      switch(_selectRadio){
        case Constants.teacher:
          final TeacherModel model = data as TeacherModel;
          selectData.add('${model.id}\n${model.teacherId}\n${model.teacherName}\n${model.courseId}\n${model.courseName}');
          break;
        case Constants.student:
          final StudentModel model = data as StudentModel;
          selectData.add('${model.id}\n${model.studentId}\n${model.studentName}\n${model.courseId}');
          break;
      }
    }
    log('Home selectData: $selectData');
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
                    if (e.key == 0) {
                      _isRegister = true;
                    }
                    if (e.key == 1) {
                      _isLogin = true;
                    }
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