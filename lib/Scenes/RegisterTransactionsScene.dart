import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/Database/RegisterTransactionDbManager.dart';
import 'package:shop_manager/Models/RegisterTransaction.dart';

class RegisterTransactionsScene extends StatefulWidget {
  RegisterTransactionDbManager dbManager;

  RegisterTransactionsScene({this.dbManager});

  @override
  _RegisterTransactionsSceneState createState() =>
      _RegisterTransactionsSceneState();
}

class _RegisterTransactionsSceneState extends State<RegisterTransactionsScene> {
  Color mainBackgroundColor = Color(0xFF56104F);
  Color darkBackgroundColor = Color(0xFFf4f4f4);
  Color darkAccentColor = Color(0xFF951556);
  Color lightAccentColor = Color(0xFFE9B4D2);
  Color darkTextColor = Color(0xFF333333);
  Color lightTextColor = Color(0xFFFEFEFE);
  Color lightTransparentTextColor = Color(0xFFDCDCDC);

  List<RegisterTransaction> transactions = new List();

  @override
  void initState() {
    super.initState();
    fillTrasactionList();
  }

  fillTrasactionList() async {
    transactions = await widget.dbManager.getTransactions();
    if (transactions == null) {
      setState(() {

      transactions = [
        RegisterTransaction(date: "02/01/2020",message: "Payment fin du mois", value: 25000, type: true),
        RegisterTransaction(date: "02/02/2020",message: "Payment fin du mois", value: 35000, type: true),
        RegisterTransaction(date: "02/03/2020",message: "Payment du loyer", value: 5000, type: false),
      ];
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkAccentColor,
      appBar: AppBar(
        backgroundColor: darkAccentColor,
        elevation: 0,
        title: Text("Register"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: <Widget>[

          Expanded(
            child: ListView.separated(itemBuilder: (context, index){
              return salesInfoCard(index, transactions[index]);
            }
            , separatorBuilder: (context, index) => Divider(height: 3,color: Colors.transparent), itemCount: transactions.length),
          )
        ],
      ),
    );
  }

  Widget salesInfoCard(int index, RegisterTransaction transaction) {
    return GestureDetector(
      onTap: () {},
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
                      transaction.type ? darkAccentColor : mainBackgroundColor,
                  child: Icon(transaction.type ? Icons.add : Icons.remove,
                      color: lightTextColor)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(transaction.message,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkTextColor)),
                      Text(transaction.date,
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: darkTextColor)),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(transaction.value.toString() + " Da",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
