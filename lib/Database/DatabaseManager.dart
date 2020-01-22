import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  String dbName = "hibashop.db";
  String tableName = "salesInfo";
  String idColumn = "id";
  String informationColumn = "information";
  String priceColumn = "price";
  String typeColumn = "type";

  Future<String> getDatabasePath(String dbName) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    return path;
  }

  Future createDatabase(Database db) async {
    String sqlQuery = "CREATE TABLE " +
        tableName +
        " ($idColumn INTEGER PRIMARY KEY," +
        "$informationColumn TEXT," +
        "$priceColumn INTEGER," +
        "$typeColumn BIT)";

    await db.execute(sqlQuery);
  }

  Future initDatabase() async {

    //custom function to get db path
    String path = await getDatabasePath(dbName);

    await deleteDatabase(path);

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      createDatabase(db);
    });

    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $tableName ($informationColumn, $priceColumn, $typeColumn) VALUES ("info", 155, 1)');
      print('inserted1: $id1');
    });

    List<Map> list = await database.rawQuery('SELECT * FROM $tableName');
    print("element " + list.elementAt(0).values.toList().toString());
  }
}
