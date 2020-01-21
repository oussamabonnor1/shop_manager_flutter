import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Shop Manager",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Color mainBackgroundColor = Color(0xFF56104F);
  static Color darkBackgroundColor = Color(0xFFf4f4f4);
  static Color darkAccentColor = Color(0xFF951556);
  static Color lightAccentColor = Color(0xFFE9B4D2);
  static Color darkUiColor = Color(0xFF4a3943);
  static Color darkTextColor = Color(0xFF565656);
  static Color lightTextColor = Color(0xFFFEFEFE);
  static Color lightTransparentTextColor = Color(0xFFDCDCDC);

  int totalAmount, todayAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 1270;
    todayAmount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activité d'aujourdhui"),
        backgroundColor: mainBackgroundColor,
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
              color: darkAccentColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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
                          fontSize: 20, color: lightTransparentTextColor),
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
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: lightAccentColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text("Vente",
                          style:
                              TextStyle(color: lightTextColor, fontSize: 18)),
                    ),
                    onPressed: () {
                      setState(() {
                        sellingDialog(context).then((onValue) {
                          sellingAction(onValue);
                        });
                      });
                    }),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: darkUiColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text("Achat",
                          style:
                              TextStyle(color: lightTextColor, fontSize: 18)),
                    ),
                    onPressed: () {})
              ],
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(height: 3, color: Colors.transparent),
                    itemCount: 5,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    itemBuilder: (context, index) {
                      return salesInfoCard(
                          index % 2 == 0,
                          index,
                          "Explication & infos & application",
                          16.3,
                          index * pow(10, index + 1));
                    }))
          ],
        ),
      ),
    );
  }

  Widget salesInfoCard(
      bool type, int index, String title, double weight, int price) {
    return Card(
      color: lightTextColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: type ? lightAccentColor : darkUiColor,
                child: Icon(
                  type ? Icons.add : Icons.remove,
                  color: lightTextColor,
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTextColor)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("$weight g",
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFA0A0A0))),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(price.toString() + " Da",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[600],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  int sellingAction(int amount) {
    todayAmount += amount;
    totalAmount += amount;
  }

  Future<int> sellingDialog(BuildContext context) {
    TextEditingController infoController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Remplissez vos infos"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[TextField(controller: infoController)],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context)
                          .pop(int.parse(infoController.text.toString()));
                    });
                  },
                  child: Text("Ajouter")),
            ],
          );
        });
  }
}
