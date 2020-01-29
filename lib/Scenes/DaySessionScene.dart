import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/Database/DatabaseManager.dart';
import 'package:shop_manager/Database/DayInfoDbManager.dart';
import 'package:shop_manager/Database/SalesInfoDbManager.dart';
import 'package:shop_manager/Models/DaySalesInfo.dart';
import 'package:shop_manager/Models/SalesInfo.dart';
import 'package:shop_manager/Scenes/HomeScene.dart';
import 'package:shop_manager/Scenes/SalesInfoDetails.dart';

class DaySessionScene extends StatefulWidget {
  DaySalesInfo daySalesInfo;
  DatabaseManager dbManager;

  DaySessionScene(this.dbManager, this.daySalesInfo);

  @override
  _DaySessionSceneState createState() => _DaySessionSceneState();
}

class _DaySessionSceneState extends State<DaySessionScene> with RouteAware {
  Color mainBackgroundColor = Color(0xFF56104F);
  Color darkBackgroundColor = Color(0xFFf4f4f4);
  Color darkAccentColor = Color(0xFF951556);
  Color lightAccentColor = Color(0xFFE9B4D2);
  Color darkTextColor = Color(0xFF333333);
  Color lightTextColor = Color(0xFFFEFEFE);
  Color lightTransparentTextColor = Color(0xFFDCDCDC);

  List<String> filters = ["Tout", "Vendu", "Acheté"];
  int totalAmount, todayAmount, selectedFilter;
  List<SalesInfo> salesInfoList = List();
  SalesInfoDbManager salesInfoDbManager;
  DaySalesInfoDbManager daySalesInfoDbManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    super.didPopNext();
    fillSalesList();
  }

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    todayAmount = 0;
    selectedFilter = 0;
    daySalesInfoDbManager = new DaySalesInfoDbManager(widget.dbManager.db);
    salesInfoDbManager = new SalesInfoDbManager(widget.dbManager.db);
    fillSalesList();
  }

  void fillSalesList() async {
    todayAmount = 0;
    totalAmount = await widget.dbManager.getRegisterInfo();
    salesInfoList =
        await salesInfoDbManager.getAllSalesInfo(widget.daySalesInfo.month);
    setState(() {
      if (salesInfoList == null) {
        salesInfoList = new List();
        print("not success");
      } else {
        salesInfoList.forEach((element) {
          int amount = element.type ? element.amount : 0;
          todayAmount += amount;
        });
        widget.daySalesInfo.dailyProfit = todayAmount;
        daySalesInfoDbManager.update(widget.daySalesInfo);
      }
    });
  }

  void filterSalesList() async {
    salesInfoList = await salesInfoDbManager.getAllSalesInfo(widget.daySalesInfo.month);
    setState(() {
      if (salesInfoList == null) {
        salesInfoList = new List();
      } else if(selectedFilter != 0) {
        for(int i = 0; i < salesInfoList.length; i++){
          if(salesInfoList.elementAt(i).type == (selectedFilter != 1))
            salesInfoList.removeAt(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activité d'aujourdhui"),
        backgroundColor: darkAccentColor,
        centerTitle: true,
        titleSpacing: 5,
      ),
      body: Stack(children: <Widget>[
        Container(
          color: darkBackgroundColor,
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Hero(
                            tag: "logo",
                            child: Image.asset(
                              "images/inAppLogo.png",
                              height: 120,
                            ),
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
                    itemBuilder: (context, index) {
                      return index == selectedFilter
                          ? selectedFilterCard(filters.elementAt(index))
                          : unselectedFilterCard(
                              filters.elementAt(index), index);
                    },
                    itemCount: filters.length,
                    scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(height: 3, color: Colors.transparent),
                      itemCount: salesInfoList.length,
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      itemBuilder: (context, index) =>
                          salesInfoCard(index, salesInfoList[index]))),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: darkAccentColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(10))),
                  child: IconButton(
                      icon: Icon(Icons.attach_money, color: Colors.white),
                      onPressed: () {
                        salesActionDialog(context, true).then((onValue) {
                          if (onValue != null) sellingAction(onValue);
                        });
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: mainBackgroundColor,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10))),
                  child: IconButton(
                      icon: Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        salesActionDialog(context, false).then((onValue) {
                          if (onValue != null) buyingAction(onValue);
                        });
                      }),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget salesInfoCard(int index, SalesInfo info) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    SalesInfoDetails(info, salesInfoDbManager, widget.dbManager)));
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
    widget.daySalesInfo.dailyProfit = todayAmount;

    widget.dbManager.updateRegisterInfo(totalAmount);
    salesInfoList.insert(0, info);
    daySalesInfoDbManager.update(widget.daySalesInfo);
  }

  void buyingAction(SalesInfo info) {
    totalAmount -= info.amount;
    widget.daySalesInfo.dailyProfit = todayAmount;

    widget.dbManager.updateRegisterInfo(totalAmount);
    salesInfoList.insert(0, info);
    daySalesInfoDbManager.update(widget.daySalesInfo);
  }

  Widget selectedFilterCard(String filter) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkAccentColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Center(
            child: Text(
              filter,
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

  Widget unselectedFilterCard(String filter, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
          filterSalesList();
        });
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: mainBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Center(
            child: Text(
              filter,
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

  Future<SalesInfo> salesActionDialog(BuildContext context, bool type) {
    TextEditingController infoController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          FocusNode focusNode = new FocusNode();
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
                          textInputAction: TextInputAction.next,
                          onSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          controller: infoController,
                          decoration:
                              InputDecoration(hintText: "Titre de transaction"),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        focusNode: focusNode,
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
                                    dayId: widget.daySalesInfo.month,
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
