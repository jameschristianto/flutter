import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:laundry_house/data.dart';
import 'dart:developer';

class User {
  int id;
  String userName;
  String userPhone;
  String userEmail;

  User(this.id, this.userName, this.userPhone, this.userEmail);

  User.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.userName = map['user_name'];
    this.userPhone = map['user_phone'];
    this.userEmail = map['user_email'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = this.id;
    map['user_name'] = this.userName;
    map['user_phone'] = this.userPhone;
    map['user_email'] = this.userEmail;

    return map;
  }
}

class DatabaseHelper {
  DatabaseHelper._singleton();
  static final DatabaseHelper instance = DatabaseHelper._singleton();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }

    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, Data.databaseName);
    log('$path');

    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        user_name TEXT NOT NULL,
        user_phone TEXT NOT NULL,
        user_email TEXT NOT NULL
      )'''
    );
  }

  // Future<List<User>> getUserData() async {
  //   var db = await read();
  //   List<User> userList = [];
  //
  //   for(var i = 0; i < db.length; i++){
  //     userList.add(User.fromMap(db[i]));
  //   }
  //
  //   return userList;
  // }

  //Create
  Future<int> create(User user) async {
    Database db = await instance.database;
    return await db.insert(
      Data.tableName,
      user.toMap()
    );
  }

  //Read
  Future<List<Map<String, dynamic>>> read() async {
    Database db = await instance.database;
    return await db.query(
      Data.tableName
    );
  }

  //Update
  Future<int> update(User user) async {
    Database db = await instance.database;
    return await db.update(
      Data.tableName,
      user.toMap(),
      where: 'id=?',
      whereArgs: [user.id]
    );
  }

  //Delete
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      Data.tableName,
      where: 'id=?',
      whereArgs: [id]
    );
  }
}