import 'package:shop_manager/Models/SalesInfo.dart';
import 'package:sqflite/sqflite.dart';

class SalesInfoDbManager {

  Database db;
  String tableName = "salesInfo";
  String idColumn = "id";
  String dayIdColumn = "dayId";
  String informationColumn = "information";
  String priceColumn = "price";
  String typeColumn = "type";

  SalesInfoDbManager(this.db);

  Future<SalesInfo> insert(SalesInfo salesInfo) async {
    print(salesInfo.toMap().values.toList());
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

  Future<List<SalesInfo>> getAllSalesInfo(String dayId) async {
    List<Map> maps = await db.query(tableName, where: "$dayIdColumn = ?", whereArgs: [dayId]);

    if (maps.length > 0) {
      maps = maps.reversed.toList();
      List<SalesInfo> salesInfoList = List();
      maps.forEach((element) => salesInfoList.add(SalesInfo.fromMap(element)));
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
}
