import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_manager/Database/DatabaseManager.dart';
import 'package:shop_manager/Database/RegisterTransactionDbManager.dart';
import 'package:shop_manager/Models/RegisterTransaction.dart';

class RegisterTransactionsScene extends StatefulWidget {
  RegisterTransactionDbManager transactionsDbManager;
  DatabaseManager dbManager;

  RegisterTransactionsScene({this.transactionsDbManager, this.dbManager});

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
  int registerValue;

  @override
  void initState() {
    super.initState();
    fillTrasactionList();
  }

  fillTrasactionList() async {
    registerValue = await widget.dbManager.getRegisterInfo();
    transactions = await widget.transactionsDbManager.getTransactions();
    if (transactions == null) {
      setState(() {
        transactions = [
          RegisterTransaction(
              date: "02/02/2020",
              message: "Payment fin du mois",
              value: 35000,
              type: true),
          RegisterTransaction(
              date: "02/03/2020",
              message: "Payment du loyer",
              value: 5000,
              type: false),
        ];
      });
    }else{
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkAccentColor,
        elevation: 0,
        title: Text("Gestion de caisse"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Card(
            color: mainBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,8,4),
                      child: Text(
                        "Contenu de caisse",
                        style: Theme.of(context).accentTextTheme.title,
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8,4,8,8),
                      child: Text(registerValue.toString() + " Da",
                          style: Theme.of(context).accentTextTheme.title)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                          onPressed: (){
                            transactionActionDialog(context, true).then((onValue){
                              if(onValue != null)
                                transactionAction(onValue);
                            });
                          },
                        color: lightTextColor,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Retirer",
                                style: TextStyle(color: mainBackgroundColor, fontSize: 18)),
                          )),
                      MaterialButton(
                          onPressed: (){transactionActionDialog(context, false).then((onValue){
                            if(onValue != null)
                              transactionAction(onValue);
                          });},
                        color: lightTextColor,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Verser",
                                style: TextStyle(color: mainBackgroundColor, fontSize: 18)),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return salesInfoCard(index, transactions[index]);
                },
                separatorBuilder: (context, index) =>
                    Divider(height: 3, color: Colors.transparent),
                itemCount: transactions.length),
          )
        ],
      ),
    );
  }

  Widget salesInfoCard(int index, RegisterTransaction transaction) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Center(
                      child: Text("Prix: " + transaction.value.toString())),
                  content: Text(transaction.message),
                  actions: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Retour"))
                  ],
                ));
      },
      child: Card(
        color: darkAccentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                  backgroundColor: lightTextColor,
                  child: Icon(transaction.type ? Icons.add : Icons.remove,
                      color: darkAccentColor, size: 26)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(transaction.message,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: lightTransparentTextColor))
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
                          color: lightTextColor)),
                  SizedBox(height: 5),
                  Text(transaction.date,
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: lightTextColor)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<RegisterTransaction> transactionActionDialog(BuildContext context, bool type) {
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
                          type ? "images/buying.png" : "images/saving.png"),
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
                          InputDecoration(hintText: "Message"),
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
                                String date = DateFormat("dd/MM/yyyy").format(DateTime.now());

                                RegisterTransaction transactionTemp = RegisterTransaction(
                                    date: date,
                                    message: infoController.text.toString(),
                                    value: int.parse(
                                        amountController.text.toString()),
                                    type: type);
                                widget.transactionsDbManager.insert(transactionTemp);
                                Navigator.of(context).pop(transactionTemp);
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

  void transactionAction(RegisterTransaction transaction){
    registerValue += transaction.type ? -transaction.value : transaction.value;
    widget.dbManager.updateRegisterInfo(registerValue);
    transactions.insert(0, transaction);
  }

}

