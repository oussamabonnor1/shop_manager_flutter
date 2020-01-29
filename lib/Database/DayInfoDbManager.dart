import 'package:shop_manager/Models/DaySalesInfo.dart';
import 'package:sqflite/sqflite.dart';

class DaySalesInfoDbManager {
  Database db;
  String tableName = "daySalesInfo";
  String monthColumn = "month";
  String dayColumn = "day";
  String dailyProfitColumn = "dailyProfit";

  DaySalesInfoDbManager(this.db);

  Future<DaySalesInfo> insert(DaySalesInfo salesInfo) async {
    print(salesInfo.toMap().values.toList());
    salesInfo.month = await db.insert(tableName, salesInfo.toMap());
    return salesInfo;
  }

  Future<DaySalesInfo> getDayInfo(int month, int day) async {
    List<Map> maps = await db.query(tableName,
        where: '$monthColumn = ? AND $dayColumn = ?', whereArgs: [month, day]);
    if (maps.length > 0) {
      return DaySalesInfo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DaySalesInfo>> getAllDailySalesInfo(int month) async {
    List<Map> maps = await db
        .query(tableName, where: "$monthColumn = ?", whereArgs: [month]);

    if (maps.length > 0) {
      maps = maps.reversed.toList();
      List<DaySalesInfo> salesInfoList = List();
      maps.forEach(
          (element) => salesInfoList.add(DaySalesInfo.fromMap(element)));
      return salesInfoList;
    }
    return null;
  }

  Future<int> deleteDaySalesInfo(int month, int day) async {
    return await db
        .delete(tableName, where: '$monthColumn = ? AND $dayColumn = ?', whereArgs: [month, day]);
  }

  Future<int> update(DaySalesInfo salesInfo) async {
    return await db.update(tableName, salesInfo.toMap(),
        where: '$monthColumn = ? AND $dayColumn = ?', whereArgs: [salesInfo.month, salesInfo.day]);
  }
}
