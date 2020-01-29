String idColumn = "month";
String dayColumn = "day";
String dailyProfitColumn = "dailyProfit";

class DaySalesInfo {
  int month, day;
  int dailyProfit;

  DaySalesInfo({this.month, this.day, this.dailyProfit});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      idColumn: month,
      dayColumn: day,
      dailyProfitColumn: dailyProfit,
    };
    return map;
  }

  DaySalesInfo.fromMap(Map<String, dynamic> map) {
    month = map[idColumn];
    day = map[dayColumn];
    dailyProfit = map[dailyProfitColumn];
  }
}
