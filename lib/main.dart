
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_manager/Database/DatabaseManager.dart';
import 'package:shop_manager/Database/SalesInfoDbManager.dart';
import 'package:shop_manager/Models/DaySalesInfo.dart';
import 'package:shop_manager/Models/SalesInfo.dart';
import 'package:shop_manager/Scenes/DaySessionScene.dart';

void main() {
  runApp(MaterialApp(
      title: "Shop Manager",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/day_session_scene": (context) => HomePage(),
        "/": (context) => DaySessionScene(new DaySalesInfo(id: 0, dailyProfit: 0)),
      }));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card();
  }
}
