import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  String dbName = "hibashop.db";

  String tableSalesInfoName = "salesInfo";
  String idSalesInfoColumn = "id";
  String informationColumn = "information";
  String priceColumn = "price";
  String typeColumn = "type";

  String tableDailySalesInfo = "daySalesInfo";
  String idDailySalesInfoColumn = "id";
  String dailyProfitColumn = "dailyProfit";

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
        " ($idSalesInfoColumn INTEGER," +
        "$informationColumn TEXT," +
        "$priceColumn INTEGER," +
        "$typeColumn BIT)";

    await db.execute(sqlQuery);

    sqlQuery = "CREATE TABLE IF NOT EXISTS " +
        tableDailySalesInfo +
        " ($idDailySalesInfoColumn INTEGER," +
        "$dailyProfitColumn INTEGER)";

    await db.execute(sqlQuery);
  }

  Future close() async => db.close();
}
