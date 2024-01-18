import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {

  /// view
  static String home = 'Sqflite';
  static String teacher = 'Teacher';
  static String student = 'Student';
  static String account = '帳號:';
  static String accountHint = '註冊不用輸入帳號, 註冊後畫面領取';
  static String password = '密碼:';
  static String passwordHint = '請輸入1位英文+5位數字';
  static String signUp = '註冊';
  static String login = '登入';
  static String id = 'id';
  static String teacherId = 't_id';
  static String studentId = 's_id';
  static String courseId = 'c_id';
  static String teacherName = 't_name';
  static String studentName = 's_name';
  static String courseName = 'c_name';
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


}