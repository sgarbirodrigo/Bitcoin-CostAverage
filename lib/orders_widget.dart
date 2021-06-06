import 'package:bitbybit/CreateOrderDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'EditOrderDialog.dart';

class OrdersWidget extends StatefulWidget {
  QuerySnapshot querySnapshot;
  Map<String, double> totalExpending;
  String base_unit;
  Function basecoin_onChange;
  final String userUid;

  OrdersWidget(this.querySnapshot, this.totalExpending, this.base_unit,
      this.basecoin_onChange, this.userUid);

  @override
  State<StatefulWidget> createState() {
    return _OrdersWidgetState();
  }
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Orders",
              style: TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontSize: 24,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 10,
                    color: Color.fromARGB(10, 0, 0, 0),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "The orders below will be executed everyday at 23:00 +UTC",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Arial Hebrew',
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.7)),
            ),
          ),
          Container(
            height: 100,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 96,
                    //color: Color(0xff7A7E83),
                  ),
                  bottom: 0,
                  left: 0,
                  right: 0,
                ),
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.querySnapshot.documents.length + 1,
                    itemBuilder: (context, index) {
                      return BuyOrderCard(index);
                    }),
              ],
            ),
          ),
          Container(
              height: widget.querySnapshot.documents.length > 0 ? null : 0,
              //padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Container(
                  //padding: EdgeInsets.all(10),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      padding: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            //color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffE2E6EA),
                                  blurRadius: 10,
                                  spreadRadius: 10)
                            ]),
                        width: double.infinity,
                        height: 108,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Text(
                                  "Total being sold daily:",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Arial Hebrew',
                                      fontSize: 16,
                                      color: Color(0xff5A6268)),
                                ),
                              ),
                              Expanded(
                                /*width: MediaQuery.of(context).size.width,
                                height: 64,*/
                                //width: 64,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.totalExpending.length,
                                    itemBuilder: (context, index) {
                                      List coins =
                                          widget.totalExpending.keys.toList();
                                      return GestureDetector(
                                        onTap: () {
                                          //print(coins[index]);
                                          widget
                                              .basecoin_onChange(coins[index]);
                                        },
                                        child: Container(
                                          width: 108,
                                          child: Card(
                                            child: Container(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8),
                                                  child: Text(
                                                    "${coins[index]}",
                                                    style: TextStyle(
                                                        fontFamily: 'Arial',
                                                        fontSize: 24,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Container(
                                                  height: 0,
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                  text: TextSpan(
                                                    text: 'Trading ',
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        fontSize: 12),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '\n${widget.totalExpending[coins[index]]} ${coins[index]}\n',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(text: ' daily.'),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 4,
                                                )
                                              ],
                                            )),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1.5,
                                                    color: coins[index] !=
                                                            widget.base_unit
                                                        ? Colors.white
                                                        : Color(0xff553277)),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                )),
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      )))),
          /*Container(
            height: 128,
            decoration: BoxDecoration(
              color:,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: -20.0,
                  blurRadius: 10.0,
                ),
                */ /*BoxShadow(
                  color: Colors.black,
                  spreadRadius: -12.0,
                  blurRadius: 12.0,
                ),*/ /*
              ],
            ),
            color: Color(0xffE2E6EA),
            child: ,
          ),*/
        ],
      ),
    );
  }

  Widget BuyOrderCard(int index) {
    if (index == widget.querySnapshot.documents.length) {
      return Card(
        margin: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: RadialGradient(
                  radius: 3,
                  center: Alignment.topRight,
                  colors: [
                    Color(0xff7544AF).withOpacity(0.95),
                    Color(0xff553277),
                  ])),
          width: 96,
          height: 128,
          child: Center(
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateOrderDialog(widget.userUid);
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 36,
                      ),
                      Text(
                        "New Order",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ))),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: Colors.white,
      );
    } else {
      return GestureDetector(
        onLongPress: () {
          /*showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('AlertDialog Title'),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('This is a demo alert dialog.'),
                      Text('Would you like to confirm this message?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      print('Confirmed');
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );*/
        },
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditOrderDialog(
                    widget.querySnapshot.documents[index], widget.userUid);
              });
          /*Firestore.instance
              .collection("users")
              .document("userTest")
              .collection("orders")
              .document(widget.querySnapshot.documents[index].documentID)
              .updateData({
            "active":
            !(widget.querySnapshot.documents[index].data["active"] as bool)
          });*/
        },
        child: Container(
          child: Card(
            //margin: EdgeInsets.only(top: 8, left: 8, right: 2, bottom: 8),
            child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          radius: 3,
                          center: Alignment.topRight,
                          colors: [
                        (widget.querySnapshot.documents[index].data["active"]
                                as bool)
                            ? Color(0xff7544AF)
                            : Color(0xffF7F7F7),
                        (widget.querySnapshot.documents[index].data["active"]
                                as bool)
                            ? Color(0xff553277)
                            : Color(0xffEFEFEF),
                      ])),
                  width: 124,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          widget.querySnapshot.documents[index].data["pair"],
                          style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 24,
                              color: (widget.querySnapshot.documents[index]
                                      .data["active"] as bool)
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.4)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          text: TextSpan(
                            text: 'Trading\n',
                            style: TextStyle(
                                color: (widget.querySnapshot.documents[index]
                                        .data["active"] as bool)
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.black.withOpacity(0.4),
                                fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${widget.querySnapshot.documents[index].data["amount"]} ${widget.querySnapshot.documents[index].data["pair"].toString().split("/")[1]}',
                                style: TextStyle(
                                    color: (widget
                                            .querySnapshot
                                            .documents[index]
                                            .data["active"] as bool)
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '\n for '),
                              TextSpan(
                                text:
                                    '${widget.querySnapshot.documents[index].data["pair"].toString().split("/")[0]}',
                                style: TextStyle(
                                    color: (widget
                                            .querySnapshot
                                            .documents[index]
                                            .data["active"] as bool)
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
