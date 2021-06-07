import 'package:bitbybit/CreateOrderDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'EditOrderDialog.dart';
import 'contants.dart';

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
    /*return Container(
      //height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

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
        ],
      ),
    );*/
    return Container(height: 200, child: OrdersCardWidget());
  }

  Widget OrdersCardWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      margin: EdgeInsets.only(top: 0, left: 16, bottom: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    radius: 6,
                    center: Alignment.topRight,
                    colors: [
                      Color(0xff7544AF),
                      Color(0xff553277),
                    ])),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Orders",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
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
                Expanded(
                  child: Container(),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CreateOrderDialog(widget.userUid);
                        },
                      );
                    })
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.querySnapshot.documents.length,
                //shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.2,
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                      padding:
                          EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 8),
                      child: Row(
                        children: [
                          /*Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              //color: Colors.grey,
                              color: colorsList[index],
                            ),
                            height: 24,
                            width: 24,
                            margin: EdgeInsets.only(left: 8, right: 16),
                          ),*/
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Text(
                                  widget.querySnapshot.documents[index]
                                      .data["pair"],
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 24,
                                      //fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  text: TextSpan(
                                    text: 'Trading ',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize: 12),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${widget.querySnapshot.documents[index].data["amount"]} ${widget.querySnapshot.documents[index].data["pair"].toString().split("/")[1]}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: ' for '),
                                      TextSpan(
                                        text:
                                            '${widget.querySnapshot.documents[index].data["pair"].toString().split("/")[0]}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        color: Colors.amber,
                        iconWidget: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditOrderDialog(
                                    widget.querySnapshot.documents[index],
                                    widget.userUid);
                              });
                        },
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget BuyOrderCard(int index) {
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
          ),
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
