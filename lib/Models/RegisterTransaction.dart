String messageColumn = "message";
String dateColumn = "date";
String valueColumn = "value";
String typeColumn = "type";

class RegisterTransaction {

  String message;
  String date;
  int value;
  bool type;

  RegisterTransaction({this.date, this.message, this.value, this.type});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      messageColumn: message,
      dateColumn: date,
      valueColumn: value,
      typeColumn:type == true ? 1 : 0,
    };
    return map;
  }

  RegisterTransaction.fromMap(Map<String, dynamic> map){
    message = map[messageColumn];
    date = map[dateColumn];
    value= map[valueColumn];
    type = map[typeColumn] == 1;
  }

}
