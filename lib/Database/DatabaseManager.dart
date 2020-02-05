import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  String dbName = "hibashop.db";

  String tableSalesInfoName = "salesInfo";
  String idSalesInfoColumn = "id";
  String dayIdSalesInfoColumn = "dayId";
  String informationColumn = "information";
  String priceColumn = "price";
  String typeColumn = "type";

  String tableDailySalesInfo = "daySalesInfo";
  String monthDailySalesInfoColumn = "month";
  String dayDailySalesInfoColumn = "day";
  String dailyProfitColumn = "dailyProfit";

  String tableRegisterInfo = "registerInfo";
  String registerValueColumn = "registerValue";

  String tableNameRegisterTransaction = "registerTransaction";
  String messageColumnRegisterTransaction = "message";
  String dateColumnRegisterTransaction = "date";
  String valueColumnRegisterTransaction = "value";
  String typeColumnRegisterTransaction = "type";

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
        tableSalesInfoName +
        " ($idSalesInfoColumn INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," +
        " $dayIdSalesInfoColumn TEXT," +
        "$informationColumn TEXT," +
        "$priceColumn INTEGER," +
        "$typeColumn BIT)";

    await db.execute(sqlQuery);

    sqlQuery = "CREATE TABLE IF NOT EXISTS " +
        tableDailySalesInfo +
        " ($monthDailySalesInfoColumn INTEGER," +
        "$dayDailySalesInfoColumn INTEGER," +
        "$dailyProfitColumn INTEGER)";

    await db.execute(sqlQuery);

    sqlQuery = "CREATE TABLE IF NOT EXISTS " +
        tableRegisterInfo +
        " ($registerValueColumn INTEGER)";

    await db.execute(sqlQuery);

    sqlQuery = "CREATE TABLE IF NOT EXISTS " +
        tableNameRegisterTransaction +
        " ($messageColumnRegisterTransaction TEXT," +
        " $dateColumnRegisterTransaction TEXT," +
        "$valueColumnRegisterTransaction INTEGER," +
        "$typeColumnRegisterTransaction BIT)";

    await db.execute(sqlQuery);

    int amount = await getRegisterInfo();
    if(amount < 0)
      await insertRegisterInfo();
  }

  Future<int> insertRegisterInfo() async {
    int amount = await db.insert(tableRegisterInfo, <String, dynamic>{registerValueColumn: 0});
    return amount;
  }

  Future<int> getRegisterInfo() async {
    List<Map> maps = await db.query(tableRegisterInfo);
    if (maps.length > 0) {
      return maps.first[registerValueColumn];
    }
    return -1;
  }

  Future<int> updateRegisterInfo(int amount) async {
    return await db.update(tableRegisterInfo, <String, dynamic>{registerValueColumn: amount});
  }

  Future close() async => db.close();
}
