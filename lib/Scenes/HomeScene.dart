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
        "/day_session_scene": (context) => DaySessionScene(
            null, new DaySalesInfo(month: 0, day: 0, dailyProfit: 0)),
      }));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  Color mainBackgroundColor = Color(0xFF56104F);
  Color darkBackgroundColor = Color(0xFFf4f4f4);
  Color darkAccentColor = Color(0xFF951556);
  Color lightAccentColor = Color(0xFFE9B4D2);
  Color darkTextColor = Color(0xFF333333);
  Color lightTextColor = Color(0xFFFEFEFE);
  Color lightTransparentTextColor = Color(0xFFDCDCDC);

  List<DaySalesInfo> daysSales = [];
  List<String> months = [
    "Ce mois",
    "Jan",
    "Fev",
    "Mars",
    "Avr",
    "Mai",
    "Join",
    "Jui",
    "Aou",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  DatabaseManager dbManager;
  DaySalesInfoDbManager daySalesInfoDbManager;

  int totalAmount, monthlyAmount, selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    super.didPopNext();
    fillInformation(DateTime.now().month);
  }

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    monthlyAmount = 0;

    dbManager = DatabaseManager();
    dbManager.initDatabase().then((onValue) {
      daySalesInfoDbManager = DaySalesInfoDbManager(dbManager.db);
      fillInformation(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Contenu de caisse",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: lightTransparentTextColor)),
                                Text(
                                  "$totalAmount Da",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: lightTransparentTextColor),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text("Gain du mois:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: lightTextColor)),
                                Text(
                                  "$monthlyAmount Da",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: lightTextColor),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/inAppLogo.png",
                                  height: 120,
                                )
                                //SvgPicture.asset("images/cookie.svg",height: 120,),
                                )
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
                                dailySalesInfoCard(index, daysSales[index]),
                            separatorBuilder: (context, index) =>
                                Divider(height: 3, color: Colors.transparent),
                            itemCount: daysSales.length)),
                    SizedBox(
                      height: 45,
                    )
                  ])),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                color: darkAccentColor),
            child: Center(
              child: CircleAvatar(
                backgroundColor: lightAccentColor,
                child: IconButton(
                    icon: Icon(Icons.create, color: lightTextColor),
                    onPressed: () async {
                      int day = DateTime.now().day;
                      int month = DateTime.now().month;
                      DaySalesInfo lastEntry =
                          await daySalesInfoDbManager.getDayInfo(month, day);
                      if (lastEntry == null) {
                        DaySalesInfo daySessionTemp =
                            await daySalesInfoDbManager.insert(DaySalesInfo(
                                month: month, day: day, dailyProfit: 0));
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => DaySessionScene(
                                    dbManager, daySessionTemp)));
                      }
                    }),
              ),
            ),
          ),
        )
      ]),
    ));
  }

  Widget dailySalesInfoCard(int index, DaySalesInfo info) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => DaySessionScene(dbManager, info)));
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
                  child: Text(info.month.toString(),
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
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey[600],
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
          fillInformation(selectedCategory + 2);
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

  fillInformation(int month) async {
    daysSales = await daySalesInfoDbManager.getAllDailySalesInfo(month);
    if (daysSales == null) {
      daysSales = List();
    }
    daysSales.forEach((element) => monthlyAmount += element.dailyProfit);
  }
}
