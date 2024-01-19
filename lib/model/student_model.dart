import '../util/constants.dart';

class StudentModel {

  int id = 0;
  String studentId = '';
  String studentPassword = '';
  String studentName = '';
  String courseId = '';
  StudentModel(this.id, this.studentId, this.studentPassword, this.studentName, this.courseId);

  Map<String, Object> toMap() {
    Map<String, Object> map = <String, Object>{
      Constants.studentId: studentId,
      Constants.studentPassword: studentPassword,
      Constants.studentName: studentName,
      Constants.courseId: courseId,
    };
    if (id > 0) {
      map[Constants.id] = id;
    }
    return map;
  }

  StudentModel.fromMap(Map<dynamic, dynamic> map) {
    id = map[Constants.id];
    studentId = map[Constants.studentId];
    studentPassword = map[Constants.studentPassword];
    studentName = map[Constants.studentName];
    courseId = map[Constants.courseId];
  }

}