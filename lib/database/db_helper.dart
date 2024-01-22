import 'dart:developer';

import 'package:outlands_ans2/model/teacher_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/student_model.dart';
import '../util/constants.dart';

class DBHelper {

  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database? _db;

  DBHelper.internal();

  late Database dbClient;

  dynamic d;

  List<int> listTransaction = [];

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, '${Constants.dbName}.db');
    final db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS ${Constants.teacher}");
    await db.execute('''
          CREATE TABLE ${Constants.teacher} (
            ${Constants.id} INTEGER PRIMARY KEY,
            ${Constants.teacherId} TEXT,
            ${Constants.teacherPassword} TEXT,
            ${Constants.teacherName} TEXT,
            ${Constants.courseId} TEXT,
            ${Constants.courseName} TEXT)
          ''');
    await db.execute("DROP TABLE IF EXISTS ${Constants.student}");
    await db.execute('''
          CREATE TABLE ${Constants.student} (
            ${Constants.id} INTEGER PRIMARY KEY,
            ${Constants.studentId} TEXT,
            ${Constants.studentPassword} TEXT,
            ${Constants.studentName} TEXT,
            ${Constants.courseId} TEXT)
          ''');
  }

  /// 打開
  Future<void> open() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, '${Constants.dbName}.db');
    await openDatabase(path);
  }

  /// 插入
  Future<List<int>> insert<T>(String tableName, List listModel) async {
    await open();
    dbClient = (await db)!;
    await dbClient.transaction((txn) async {
      for (dynamic model in listModel) {
        listTransaction.add(await txn.insert(tableName, model.toMap()));
      }
    });
    return listTransaction;
  }

  /// 查詢
  Future<List<T>> select<T>() async {
    await open();
    dbClient = (await db)!;
    List<Map> maps = await dbClient.query(
        T == TeacherModel ? Constants.teacher : T == StudentModel ? Constants.student : '',
        columns: T == TeacherModel ? Constants.listTeacher : T == StudentModel ? Constants.listStudent : [],
    );
    List<T> list = [];
    for (Map element in maps) {
      switch(T){
        case TeacherModel:
          list.add((TeacherModel.fromMap(element)) as T);
          break;
        case StudentModel:
          list.add((StudentModel.fromMap(element)) as T);
          break;
      }
    }
    return Future.value(list);
  }

  /// 根據params查找
  Future<T> selectByParam<T>(String tableName, List<String> listColumns, String where, List args) async {
    await open();
    dbClient = (await db)!;
    List<Map> maps = await dbClient.query(tableName, columns: listColumns, where: '$where = ?', whereArgs: args);
    log('selectByParam $maps');
    switch(T){
      case TeacherModel:
        d = TeacherModel.fromMap(maps.first);
        break;
      case StudentModel:
        d = StudentModel.fromMap(maps.first);
        break;
    }
    return Future.value(d);
  }

  // Future<FiveBean> selectFiveBean(String tableName, List listColumns, String key, List args) async {
  //   await open();
  //   dbClient = (await db)!;
  //   List<Map> maps = await dbClient.query(tableName, columns: listColumns, where: key, whereArgs: args);
  //   return FiveBean.fromMap(maps.first);
  // }

  /// 刪除
  Future<int> delete(String tableName, {String? where, List? args}) async {
    int transaction = 0;
    dbClient = (await db)!;
    await dbClient.transaction((txn) async {
      transaction = await txn.delete(tableName, where: where == null ? null : '$where = ?', whereArgs: args);
    });
    return transaction;
  }

  Future<int> deleteTable(String tableName) async {
    dbClient = (await db)!;
    return await dbClient.delete(tableName);
  }

  Future<void> deleteDatabase(String path) => databaseFactory.deleteDatabase(path);

  // // 更新
  // Future<int> update(String tableName, List list, String key, List args) async {
  //   dbClient = await db;
  //   int future = 0;
  //   switch(tableName){
  //     case Constants.tableProduct:
  //       for(var bean in list){
  //         FiveBean fiveBean = bean as FiveBean;
  //         future = await dbClient.update(tableName, fiveBean.toMap(), where: key, whereArgs: args);
  //         /*if (kDebugMode) {
  //           print('Five update ${fiveBean.id}');
  //         }*/
  //       }
  //       break;
  //   }
  //   return future;
  // }

  /// 關閉
  Future<void> close() async {
    dbClient = (await db)!;
    await dbClient.close();
  }

}