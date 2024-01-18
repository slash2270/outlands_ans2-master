import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:outlands_ans2/base/base_page.dart';
import 'package:outlands_ans2/util/constants.dart';

class MyHomePage extends BasePage {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends BasePageState<MyHomePage> {

  String _selectRadio = '';
  late bool _isRegister = false, _isLogin = false, _isSecret = true;
  late final List<String> _listHelper = ['', ''], _listText = ['', ''];
  late final List<TextEditingController> _listController = [TextEditingController(), TextEditingController()];

  @override
  String get title => Constants.home;

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
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.w),
                borderSide: BorderSide(color: Colors.blue, width: 1.w)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.w),
                borderSide: BorderSide(color: Colors.blue, width: 1.w)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.w),
                borderSide: BorderSide(color: Colors.black, width: 1.w)),
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

  Widget _btn(int index, String text, {Function? tap}) {
    return Ink(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        border: Border.all(width: 1.w),
      ),
      child: InkWell(
        child: Text(text, maxLines: 1, style: Constants.textButton),
        onTap: () => tap == null ? null : tap(),
      ),
    );
  }

  Future<void> _check() async {
    for (int i = 0; i < _listHelper.length; i++) {
      if (_isRegister || _isLogin) {
        if (_selectRadio.isEmpty) {
          _listHelper[i] = '請選擇身份';
        } else {
          if (_isRegister) {
            if (i == 0) {
              continue;
            } else {
              if (_listController[i].text.length < 6 || _listController[i].text.isEmpty) {
                _listHelper[i] = '請輸入6位英文數字';
              } else {
                _checkPassword(i);
              }
            }
          }
          if (_isLogin) {
            if (_listController[i].text.length < 6 || _listController[i].text.isEmpty) {
              _listHelper[i] = '請輸入6位英文數字';
            } else {
              i == 0 ? _checkAccount(i) : _checkPassword(i) ;
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
      final SnackBarAction snackBarAction = SnackBarAction(label: '', onPressed: () => Navigator.pop(context));
      SnackBar(content: Text('註冊成功', style: Constants.textField22), action: snackBarAction);
      return;
    }
    final list = _listHelper.where((helper) => helper == '驗證成功').toList();
    _isRegister = false;
    _isLogin = false;
    if (_isLogin && list.length == _listHelper.length) {
      context.push('/${_selectRadio == Constants.teacher ? Constants.teacher : _selectRadio == Constants.student ? Constants.student : ""}');
      return;
    }
  }

  void _checkAccount(int i) {
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
    final bool matched = exp.hasMatch(_listController[i].text);
    _listHelper[i] = matched ? '驗證成功' : '請輸入$text + 5位數字';
  }

  void _checkPassword(int i) {
    RegExp exp = RegExp(r"[A-za-z]");
    bool matched = exp.hasMatch(_listController[i].text);
    if (!matched) {
      setState(() => _listHelper[i] = Constants.passwordHint);
      return;
    }
    exp = RegExp(r"[0-9]");
    matched = exp.hasMatch(_listController[i].text);
    _listHelper[i] = matched ? '驗證成功' : Constants.passwordHint;
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
                   _btn(e.key, e.value, tap: () {
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