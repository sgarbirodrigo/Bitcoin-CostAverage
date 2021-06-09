import 'package:bitbybit/CreateOrderDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../EditOrderDialog.dart';
import '../../contants.dart';
import '../../models/settings_model.dart';
import '../../models/user_model.dart';

class OrdersWidget extends StatefulWidget {
  Settings settings;
  User user;

  OrdersWidget(this.user, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _OrdersWidgetState();
  }
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0, bottom: 8, left: 24, right: 32),
                  child: Text(
                    "Orders",
                    style: TextStyle(
                      fontFamily: 'Arial Rounded MT Bold',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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
                Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: IconButton(
                      iconSize: 24,
                      color: Colors.black.withOpacity(0.6),
                      icon: Icon(
                        Icons.add,
                        //color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CreateOrderDialog(
                                widget.user.firebasUser.uid);
                          },
                        );
                      }),
                ),
              ],
            ),
            Expanded(
                child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              margin: EdgeInsets.only(top: 0, left: 16, bottom: 16, right: 16),
              child:  ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.user.orderItems.length,
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
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 16, right: 8),
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(
                                    widget.user.orderItems[index].pair,
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 24,
                                        //fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.only(top: 0, bottom: 0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    text: TextSpan(
                                      text: 'Trading ',
                                      style: TextStyle(
                                          color: Colors.black
                                              .withOpacity(0.4),
                                          fontSize: 12),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                          '${widget.user.orderItems[index].amount} ${widget.user.orderItems[index].pair.split("/")[1]}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        TextSpan(text: ' for '),
                                        TextSpan(
                                          text:
                                          '${widget.user.orderItems[index].pair.split("/")[0]}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold),
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
                                      widget.user.orderItems[index],
                                      widget.user.firebasUser.uid);
                                });
                          },
                        )
                      ],
                    );
                  }),
            ))
          ],
        ));
  }
}
