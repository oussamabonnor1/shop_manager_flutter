String monthColumn = "month";
String dayColumn = "day";
String dailyProfitColumn = "dailyProfit";

class DaySalesInfo {
  int month, day;
  int dailyProfit;

  DaySalesInfo({this.month, this.day, this.dailyProfit});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      monthColumn: month,
      dayColumn: day,
      dailyProfitColumn: dailyProfit,
    };
    return map;
  }

  DaySalesInfo.fromMap(Map<String, dynamic> map) {
    month = map[monthColumn];
    day = map[dayColumn];
    dailyProfit = map[dailyProfitColumn];
  }
}
