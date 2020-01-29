import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  int totalAmount, todayAmount;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Activité d'aujourdhui"),
          backgroundColor: darkAccentColor,
        ),
        body: Container(
            color: darkBackgroundColor,
            padding: EdgeInsets.all(8),
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
                            Text("Gain du jour:",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: lightTextColor)),
                            Text(
                              "$todayAmount Da",
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
              ],
            )));
  }
}
