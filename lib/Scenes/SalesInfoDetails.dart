import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_manager/Database/SalesInfoDbManager.dart';
import 'package:shop_manager/Models/SalesInfo.dart';

class SalesInfoDetails extends StatefulWidget {

  SalesInfo info;
  SalesInfoDbManager salesDbManager;

  SalesInfoDetails(this.info, this.salesDbManager);

  @override
  _SalesInfoDetailsState createState() => _SalesInfoDetailsState();
}

class _SalesInfoDetailsState extends State<SalesInfoDetails>{

  Color mainBackgroundColor = Color(0xFF56104F);
  Color darkBackgroundColor = Color(0xFFf4f4f4);
  Color darkAccentColor = Color(0xFF951556);
  Color lightAccentColor = Color(0xFFE9B4D2);
  Color darkTextColor = Color(0xFF333333);
  Color lightTextColor = Color(0xFFFEFEFE);
  Color lightTransparentTextColor = Color(0xFFDCDCDC);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 7, child: SizedBox()),
                Expanded(
                  flex: 6,
                  child: Card(
                    color: Color(0xFF490E43),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(widget.info.type ? "Vente" : "Achat",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: lightTransparentTextColor)),
                              GestureDetector(
                                onTap: () {
                                  widget.salesDbManager.deleteSalesInfo(widget.info.id);
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: darkAccentColor,
                                  child: Icon(Icons.delete,
                                      color: lightTransparentTextColor,
                                      size: 24),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                              widget.info.information,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: lightTransparentTextColor)),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                            decoration: BoxDecoration(
                                color: darkAccentColor,
                                borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(15), bottomRight: Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(widget.info.type ? "+ "+ widget.info.amount.toString() +" Da"
                                    : "- "+ widget.info.amount.toString() +" Da",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: lightTransparentTextColor)),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 4, child: Image.asset("images/cookie_png.png")),
                Expanded(flex: 3, child: SizedBox()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
