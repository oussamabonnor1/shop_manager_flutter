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
  static Color darkTextColor = Color(0xFFE3E3E3);
  static Color lightTextColor = Color(0xFFFEFEFE);

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
                            color: darkTextColor)),
                    SizedBox(height: 10),
                    Text(
                      "0.00 Da",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: darkTextColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Gain du jour:",
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: lightTextColor)),
                    SizedBox(height: 10),
                    Text(
                      "0.00 Da",
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
                    onPressed: () {}),
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
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          height: 3,
                          color: Colors.transparent,
                        ),
                    itemCount: 5,
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                    itemBuilder: (context, index) {
                      return salesInfoCard(index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget salesInfoCard(int index) {
    return Card(
      color: lightAccentColor,
      child: Text(
        "$index",
      ),
    );
  }
}
