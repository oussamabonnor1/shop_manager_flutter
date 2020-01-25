import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/Database/DatabaseManager.dart';
import 'package:shop_manager/Database/SalesInfoDbManager.dart';
import 'package:shop_manager/Models/SalesInfo.dart';
import 'package:shop_manager/Scenes/SalesInfoDetails.dart';

class DaySessionScene extends StatefulWidget {
  @override
  _DaySessionSceneState createState() => _DaySessionSceneState();
}

class _DaySessionSceneState extends State<DaySessionScene> {

  Color mainBackgroundColor = Color(0xFF56104F);
  Color darkBackgroundColor = Color(0xFFf4f4f4);
  Color darkAccentColor = Color(0xFF951556);
  Color lightAccentColor = Color(0xFFE9B4D2);
  Color darkTextColor = Color(0xFF333333);
  Color lightTextColor = Color(0xFFFEFEFE);
  Color lightTransparentTextColor = Color(0xFFDCDCDC);

  int totalAmount, todayAmount;
  List<SalesInfo> salesInfoList = List();
  DatabaseManager dbManager;
  SalesInfoDbManager salesInfoDbManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    todayAmount = 0;

    dbManager = new DatabaseManager();
    dbManager.initDatabase().then((onValue) {
      salesInfoDbManager = new SalesInfoDbManager(dbManager.db);
      fillSalesList(salesInfoDbManager);
    });
  }

  void fillSalesList(SalesInfoDbManager dbManager) async {
    salesInfoList = await dbManager.getAllSalesInfo(0);
    setState(() {
      if (salesInfoList == null) {
        salesInfoList = new List();
        print("not success");
      } else {
        print("success");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: darkAccentColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text("Vente",
                          style:
                              TextStyle(color: lightTextColor, fontSize: 18)),
                    ),
                    onPressed: () {
                      setState(() {
                        salesActionDialog(context, true).then((onValue) {
                          if (onValue != null) sellingAction(onValue);
                        });
                      });
                    }),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: mainBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text("Achat",
                          style:
                              TextStyle(color: lightTextColor, fontSize: 18)),
                    ),
                    onPressed: () {
                      setState(() {
                        salesActionDialog(context, false).then((onValue) {
                          if (onValue != null) buyingAction(onValue);
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
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => SalesInfoDetails(info)));
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
                  backgroundColor:
                      info.type ? darkAccentColor : mainBackgroundColor,
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

  Future<SalesInfo> salesActionDialog(BuildContext context, bool type) {
    TextEditingController infoController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                          type ? "images/saving.png" : "images/buying.png"),
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: infoController,
                          decoration:
                              InputDecoration(hintText: "Titre de transaction"),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(hintText: "Montant"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop(null);
                              });
                            },
                            child: Text("Retour",
                                style: TextStyle(color: Colors.white)),
                            color: mainBackgroundColor,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              setState(() {
                                SalesInfo infoTemp = SalesInfo(
                                    id: 0,
                                    information: infoController.text.toString(),
                                    amount: int.parse(
                                        amountController.text.toString()),
                                    type: type);
                                salesInfoDbManager.insert(infoTemp);
                                Navigator.of(context).pop(infoTemp);
                              });
                            },
                            child: Text("Ajouter",
                                style: TextStyle(color: Colors.white)),
                            color: darkAccentColor,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
