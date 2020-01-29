import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_manager/Database/DatabaseManager.dart';
import 'package:shop_manager/Database/DayInfoDbManager.dart';
import 'package:shop_manager/Models/DaySalesInfo.dart';
import 'package:shop_manager/Scenes/DaySessionScene.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(MaterialApp(
      title: "Shop Manager",
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/day_session_scene": (context) =>
            DaySessionScene(new DaySalesInfo(id: 0, dailyProfit: 0)),
      }));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color mainBackgroundColor = Color(0xFF56104F);
  Color darkBackgroundColor = Color(0xFFf4f4f4);
  Color darkAccentColor = Color(0xFF951556);
  Color lightAccentColor = Color(0xFFE9B4D2);
  Color darkTextColor = Color(0xFF333333);
  Color lightTextColor = Color(0xFFFEFEFE);
  Color lightTransparentTextColor = Color(0xFFDCDCDC);

  List<DaySalesInfo> daysSales = [
    DaySalesInfo(id: 0, dailyProfit: 1200),
    DaySalesInfo(id: 1, dailyProfit: 1500),
    DaySalesInfo(id: 2, dailyProfit: 3500),
    DaySalesInfo(id: 3, dailyProfit: 5000),
    DaySalesInfo(id: 4, dailyProfit: 5000),
  ];
  List<String> months = ["Ce mois", "Jan", "Fev", "Mars", "Avr", "Mai", "J"];

  DatabaseManager dbManager;
  DaySalesInfoDbManager daySalesInfoDbManager;

  int totalAmount, monthlyAmount, selectedCategory;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    monthlyAmount = 0;
    selectedCategory = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkAccentColor,
          title: Text("Home"),
          centerTitle: true,
        ),
        body: Container(
            color: darkBackgroundColor,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: mainBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("images/inAppLogo.png", height: 80),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Text(
                                    "$totalAmount Da",
                                    style: TextStyle(
                                        fontSize: 24, color: lightTextColor),
                                  ),
                                  Text("Contenu de caisse",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: lightTransparentTextColor))
                                ]),
                                Column(children: <Widget>[
                                  Text(
                                    "$monthlyAmount Da",
                                    style: TextStyle(
                                        fontSize: 24, color: lightTextColor),
                                  ),
                                  Text("Gain du Mois:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: lightTransparentTextColor)),
                                ]),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: months.length,
                        itemBuilder: (context, index) {
                          return index == selectedCategory
                              ? selectedCategoryCard(months[index])
                              : unselectedCategoryCard(months[index], index);
                        }),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) =>
                              salesInfoCard(index, daysSales[index]),
                          separatorBuilder: (context, index) =>
                              Divider(height: 3, color: Colors.transparent),
                          itemCount: daysSales.length)),
                  BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.add), title: Text("Home")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.add), title: Text("Home")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.add), title: Text("Home")),
                    ],
                    backgroundColor: darkAccentColor,
                  )
                ])));
  }

  Widget salesInfoCard(int index, DaySalesInfo info) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => DaySessionScene(info)));
      },
      child: Card(
        color: lightTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                  backgroundColor: mainBackgroundColor,
                  child: Text(info.id.toString(),
                      style: TextStyle(color: lightTextColor))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(info.dailyProfit.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkTextColor)),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(info.dailyProfit.toString() + " Da",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600])),
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedCategoryCard(String category) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: lightAccentColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget unselectedCategoryCard(String category, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkAccentColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                  color: lightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
