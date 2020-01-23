import 'package:path/path.dart';
import 'package:shop_manager/Models/SalesInfo.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  String dbName = "hibashop.db";
  String tableName = "salesInfo";
  String idColumn = "id";
  String informationColumn = "information";
  String priceColumn = "price";
  String typeColumn = "type";

  Database db;

  Future<String> getDatabasePath(String dbName) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    return path;
  }

  Future initDatabase() async {
    //custom function to get db path
    String path = await getDatabasePath(dbName);

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      createDatabase(db);
    });

    print("database successfully opened");
  }

  Future createDatabase(Database db) async {
    String sqlQuery = "CREATE TABLE IF NOT EXISTS " +
        tableName +
        " ($idColumn INTEGER," +
        "$informationColumn TEXT," +
        "$priceColumn INTEGER," +
        "$typeColumn BIT)";

    await db.execute(sqlQuery);
  }

  Future<SalesInfo> insert(SalesInfo salesInfo) async {
    salesInfo.id = await db.insert(tableName, salesInfo.toMap());
    return salesInfo;
  }

  /*Future<SalesInfo> getSalesInfo(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [idColumn, informationColumn, priceColumn, typeColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SalesInfo.fromMap(maps.first);
    }
    return null;
  }*/

  Future<List<SalesInfo>> getAllSalesInfo(int id) async {
    List<Map> maps = await db.query(tableName);
    maps.forEach((row) => print(row));

    if (maps.length > 0) {
      List<SalesInfo> salesInfoList = List();
      for (int i = 0; i < maps.length; i++) {
        salesInfoList.add(SalesInfo.fromMap(maps[i]));
      }
      return salesInfoList;
    }
    return null;
  }

  Future<int> deleteSalesInfo(int id) async {
    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> update(SalesInfo salesInfo) async {
    return await db.update(tableName, salesInfo.toMap(),
        where: '$idColumn = ?', whereArgs: [salesInfo.id]);
  }

  Future close() async => db.close();
}
