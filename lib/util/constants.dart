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
  static const String passwordHint = '請輸入1位英文+5位數字';
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
  static const String courseHint = '請輸入課程名稱';
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
  /// bodrer
  static InputBorder textBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.w),
      borderSide: BorderSide(color: Colors.blue, width: 1.w)
  );
  /// function
  static String setAccount(int length) {
    if (length < 10) {
      return "0000$length";
    } else if (length < 100) {
      return "000$length";
    } else if (length < 1000) {
      return "00$length";
    } else if (length < 10000) {
      return "0$length";
    } else {
      return "$length";
    }
  }


}