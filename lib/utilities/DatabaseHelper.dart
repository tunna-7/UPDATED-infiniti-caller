import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/contact.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  static const String ID = 'id';
  static const String DB_NAME = 'my_phonebook.db';
  static const String TABLE = 'phonebook';
  static const String FIRST_NAME = 'firstName';
  static const String LAST_NAME = 'lastName';
  static const String IMAGE = 'image';
  static const String CELL_NUM = 'cellularNum';
  static const String HOME_NUM = 'homeNum';
  static const String WORKPLACE_NUM = 'workplaceNum';
  static const String EMAIL = 'email';
  static const String GENDER = 'gender';
  static const String BIRTHDATE = 'birthdate';
  static const String FAVORITE = 'favorite';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + DB_NAME;

    var contactDatabase =
        await openDatabase(path, version: 2, onCreate: _createDb);
    return contactDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    print('new db created');
    await db.execute(
        'CREATE TABLE $TABLE($ID TEXT PRIMERY KEY, $FIRST_NAME TEXT, $LAST_NAME TEXT, $IMAGE TEXT, $CELL_NUM INTEGER, $HOME_NUM INTEGER, $WORKPLACE_NUM INTEGER, $EMAIL TEXT, $GENDER TEXT , $BIRTHDATE TEXT, $FAVORITE BOOLEAN)');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future searchContact(String query) async {
    Database db = await this.database;

    var result = await db
        .rawQuery('SELECT * FROM $TABLE WHERE $FIRST_NAME LIKE "%$query%"');
    return result;
  }

  Future getFavorites() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $TABLE WHERE $FAVORITE = 1');
    return result;
  }

  Future<List<Map<String, dynamic>>> getContactsList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $TABLE order by $FIRST_NAME ASC');
    return result;
  }

  Future<int> addContact(Contact contact) async {
    Database db = await this.database;
    var result = await db.insert(TABLE, contact.toMap());

    return result;
  }

  Future<int> editContact(Contact contact) async {
    Database db = await this.database;
    var result = await db.update(TABLE, contact.toMap(),
        where: '$ID = ?', whereArgs: [contact.id]);

    return result;
  }

  Future<int> deleteContact(String id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $TABLE WHERE $ID = ?', ['$id']);

    return result;
  }

  Future<int> getTotalContacts() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $TABLE');

    return Sqflite.firstIntValue(x);
  }
}
