String idColumn = "id";
String dailyProfitColumn = "dailyProfit";

class DaySalesInfo {
  int id;
  int dailyProfit;

  DaySalesInfo(this.id, this.dailyProfit);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      idColumn: id,
      dailyProfitColumn: dailyProfit,
    };
    return map;
  }

  DaySalesInfo.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    dailyProfit = map[dailyProfitColumn];
  }
}
