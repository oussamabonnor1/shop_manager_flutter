import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_manager/Models/SalesInfo.dart';

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
  List<SalesInfo> salesInfoList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 1270;
    todayAmount = 0;
    salesInfoList.add(SalesInfo(information: "Sold", amount: 100, type: true));
    salesInfoList
        .add(SalesInfo(information: "Bought", amount: 150, type: false));
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("images/inAppLogo.png", height: 120,)
                      //SvgPicture.asset("images/cookie.svg",height: 120,),
                    )
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
                        sellingDialog(context, true).then((onValue) {
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
                    onPressed: () {
                      setState(() {
                        sellingDialog(context, false).then((onValue) {
                          buyingAction(onValue);
                        });
                      });
                    })
              ],
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(height: 3, color: Colors.transparent),
                    itemCount: salesInfoList.length,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    itemBuilder: (context, index) {
                      return salesInfoCard(index, salesInfoList[index]);
                    }))
          ],
        ),
      ),
    );
  }

  Widget salesInfoCard(int index, SalesInfo info) {
    return GestureDetector(
      onTap: (){
        salesInfoPopUp(context, info);
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
                  backgroundColor: info.type ? lightAccentColor : darkUiColor,
                  child: Icon(info.type ? Icons.add : Icons.remove,
                      color: lightTextColor)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(info.information,
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
                  Text(info.amount.toString() + " Da",
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

  void sellingAction(SalesInfo info) {
    todayAmount += info.amount;
    totalAmount += info.amount;
    salesInfoList.insert(0, info);
  }

  void buyingAction(SalesInfo info) {
    totalAmount -= info.amount;
    salesInfoList.insert(0, info);
  }

  Future<SalesInfo> sellingDialog(BuildContext context, bool type) {
    TextEditingController infoController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Remplissez vos infos"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: infoController,
                  decoration: InputDecoration(hintText: "Titre de transaction"),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: "Montant"),
                  keyboardType: TextInputType.number,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    setState(() {
                      SalesInfo infoTemp = SalesInfo(
                          information: infoController.text.toString(),
                          amount: int.parse(amountController.text.toString()),
                          type: type);
                      Navigator.of(context).pop(infoTemp);
                    });
                  },
                  child: Text("Ajouter")),
            ],
          );
        });
  }

  salesInfoPopUp(BuildContext context, SalesInfo info) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage(info.type ? "images/saving.png" : "images/buying.png"),
                        height: 100,
                      ),
                    ),
                    Text(
                      info.amount.toString() + " Da",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: darkTextColor),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        info.information,
                        style: TextStyle(fontSize: 20, color: darkTextColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          Text("Retour", style: TextStyle(color: Colors.white)),
                      color: darkAccentColor,
                    )
                  ],
                )
                /*Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: info.type ? lightAccentColor : darkUiColor,
              child: Icon(
                info.type ? Icons.add : Icons.remove,
                color: lightTextColor,
              )),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(info.information,
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
              Text(info.amount.toString() + " Da",
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
        ),*/
                ),
          );
        });
  }
}
