
String idColumn = "id";
String informationColumn = "information";
String priceColumn = "price";
String typeColumn = "type";

class SalesInfo{

  int id;
  String information;
  int amount;
  bool type;

  SalesInfo({this.id, this.information, this.amount, this.type});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      idColumn : id,
      informationColumn : information,
      priceColumn : amount,
      typeColumn: type == true ? 1 : 0
    };
    return map;
  }

  SalesInfo.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    information = map[informationColumn];
    amount = map[priceColumn];
    type = map[typeColumn] == 1;
  }
}