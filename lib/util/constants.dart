import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {

  /// view
  static const String home = 'Sqflite';
  static const String teacher = 'Teacher';
  static const String student = 'Student';
  static const String account = '帳號:';
  static const String accountHint = '註冊不用輸入帳號, 註冊後畫面領取';
  static const String password = '密碼:';
  static const String passwordHint = '英文數字組合';
  static const String signUp = '註冊';
  static const String login = '登入';
  static const String id = 'id';
  static const String teacherId = 't_id';
  static const String studentId = 's_id';
  static const String courseId = 'c_id';
  static const String teacherPassword = 't_password';
  static const String studentPassword = 's_password';
  static const String teacherName = 't_name';
  static const String studentName = 's_name';
  static const String course = '課程';
  static const String courseName = 'c_name';
  static const String courseHint = '請輸入課程';
  static const String name = '姓名';
  static const String nameHint = '請輸入姓名';
  static const String dataError = ', 請洽客服或網路管理員, 謝謝.';
  static const String idError = '帳號錯誤, 請重新輸入, 謝謝.';
  static const String passwordError = '密碼錯誤, 請重新輸入, 謝謝.';
  static const String verificationSuccess = '格式正確';
  static const String dbName = 'Demo';
  static const List<String> listTeacher = [id, teacherId, teacherPassword, teacherName, courseId, courseName];
  static const List<String> listStudent = [id, studentId, studentPassword, studentName, courseId];
  /// textStyle
  static TextStyle textField22 = TextStyle(
    color: Colors.black, fontSize: 22.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textField20 = TextStyle(
    color: Colors.black, fontSize: 20.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textFieldTransparent = TextStyle(
    color: Colors.transparent, fontSize: 22.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textLabel = TextStyle(
    color: Colors.grey.shade500, fontSize: 18.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textHint = TextStyle(
    color: Colors.grey.shade300, fontSize: 15.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textHelperFail = TextStyle(
    color: Colors.redAccent, fontSize: 15.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textHelperSuccess = TextStyle(
    color: Colors.greenAccent, fontSize: 15.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle textButton = TextStyle(
    color: Colors.white, fontSize: 18.sp,
    decoration: TextDecoration.none,
  );
  /// border
  static InputBorder textBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.w),
      borderSide: BorderSide(color: Colors.blue, width: 1.w)
  );

}