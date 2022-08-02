import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import '../Model/user_model.dart';

String table = 'user';

class DatabaseConnection {
  Future<Database> initializeUserDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'userData.db'),
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE $table(id INTEGER PRIMIRY KEY,name TEXT)');
    }, version: 1);
  }

  Future<void> insetUser(User user) async {
    final db = await initializeUserDB();
    await db.insert(table, user.toMap());
    print('funtion insert');
  }

  Future<List<User>> getUser() async {
    final db = await initializeUserDB();
    List<Map<String, dynamic>> qresult = await db.query(table);
    //print('lll');
    return qresult.map((e) => User.fromMap(e)).toList();
  }

  Future<void> deleteuser(int id) async {
    final db = await initializeUserDB();
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateUser(User user) async {
    final db = await initializeUserDB();
    await db.update(table, user.toMap(), where: 'id=?', whereArgs: [user.id]);
  }
}
