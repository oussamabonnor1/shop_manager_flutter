import 'package:shop_manager/Models/RegisterTransaction.dart';
import 'package:sqflite/sqflite.dart';

class RegisterTransactionDbManager {

  Database db;
  String tableName = "registerTransaction";
  String messageColumn = "message";
  String dateColumn = "date";
  String valueColumn = "value";
  String typeColumn = "type";

  RegisterTransactionDbManager(this.db);

  Future<RegisterTransaction> insert(RegisterTransaction registerTransaction) async {
    print(registerTransaction.toMap().values.toList());
    await db.insert(tableName, registerTransaction.toMap());
    return registerTransaction;
  }

  Future<List<RegisterTransaction>> getTransactions() async {
    List<Map> maps = await db.query(tableName);

    if (maps.length > 0) {
      maps = maps.reversed.toList();
      List<RegisterTransaction> registerTransactionsList = List();
      maps.forEach((element) => registerTransactionsList.add(RegisterTransaction.fromMap(element)));
      return registerTransactionsList;
    }
    return null;
  }

  Future<int> deleteRegisterTransaction(String message) async {
    return await db.delete(tableName, where: '$messageColumn = ?', whereArgs: [message]);
  }

  Future<int> update(RegisterTransaction registerTransaction) async {
    return await db.update(tableName, registerTransaction.toMap(),
        where: '$messageColumn = ?', whereArgs: [registerTransaction.message]);
  }
}
