
String idColumn = "id";
String informationColumn = "information";
String priceColumn = "price";
String typeColumn = "type";

class SalesInfo{

  int id;
  String information;
  int amount;
  bool type;

  SalesInfo({int id, this.information, this.amount, this.type});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      informationColumn : information,
      priceColumn : amount,
      typeColumn: type == true ? 1 : 0
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  SalesInfo.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    information = map[informationColumn];
    amount = map[priceColumn];
    type = map[typeColumn] == 1;
  }
}