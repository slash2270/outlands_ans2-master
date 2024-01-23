import '../util/constants.dart';

class TeacherModel {

  int? id;
  String? teacherId;
  String? teacherPassword;
  String? teacherName;
  String? courseId;
  String? courseName;
  TeacherModel({this.id, this.teacherId, this.teacherPassword, this.teacherName, this.courseId, this.courseName});

  Map<String, Object> toMap() {
    Map<String, Object> map = <String, Object>{
      Constants.teacherId: teacherId!,
      Constants.teacherName: teacherName!,
      Constants.teacherPassword: teacherPassword!,
      Constants.courseId: courseId!,
      Constants.courseName: courseName!,
    };
    if (id! > 0) {
      map[Constants.id] = id!;
    }
    return map;
  }

  TeacherModel.fromMap(Map<dynamic, dynamic> map) {
    id = map[Constants.id];
    teacherId = map[Constants.teacherId];
    teacherPassword = map[Constants.teacherPassword];
    teacherName = map[Constants.teacherName];
    courseId = map[Constants.courseId];
    courseName = map[Constants.courseName];
  }

}