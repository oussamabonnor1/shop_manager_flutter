import 'package:shop_manager/Models/DaySalesInfo.dart';
import 'package:sqflite/sqflite.dart';

class DaySalesInfoDbManager{

  Database db;
  String tableName = "daySalesInfo";
  String idColumn = "id";
  String dailyProfitColumn = "dailyProfit";

  DaySalesInfoDbManager(this.db);

  Future<DaySalesInfo> insert(DaySalesInfo salesInfo) async {
    print(salesInfo.toMap().values.toList());
    salesInfo.id = await db.insert(tableName, salesInfo.toMap());
    return salesInfo;
  }

  Future<DaySalesInfo> getDayInfo(int id) async {
    List<Map> maps = await db.query(tableName,
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return DaySalesInfo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DaySalesInfo>> getAllDailySalesInfo(int id) async {
    List<Map> maps = await db.query(tableName);

    if (maps.length > 0) {
      maps = maps.reversed.toList();
      List<DaySalesInfo> salesInfoList = List();
      maps.forEach((element) => salesInfoList.add(DaySalesInfo.fromMap(element)));
      return salesInfoList;
    }
    return null;
  }

  Future<int> deleteDaySalesInfo(int id) async {
    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> update(DaySalesInfo salesInfo) async {
    return await db.update(tableName, salesInfo.toMap(),
        where: '$idColumn = ?', whereArgs: [salesInfo.id]);
  }

}