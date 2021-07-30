
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../contants.dart';
import '../../models/settings_model.dart';
import '../../models/user_model.dart';

class BalanceWidget extends StatefulWidget {
  SettingsApp settings;
  UserManager user;

  BalanceWidget(this.user, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _BalanceWidgetState();
  }
}

class _BalanceWidgetState extends State<BalanceWidget> {
  String _priceUnit = "BRL";
  List<String> _baseCoins = ["BRL", "USDT", "BTC"];
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 0, bottom: 8, left: 24, right: 32),
                child: Text(
                  "Balance",
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
                child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Select your base coin:"),
                            content: Container(
                              height: 48,
                              width: 200,
                              child: Column(
                                children: <Widget>[
                                  //new Text("Please select an option for why you declined."),
                                  DropdownButton<String>(
                                    value: _priceUnit,
                                    underline: Container(),
                                    items: _baseCoins.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String value) {
                                      setState(() {
                                        _priceUnit = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                      /*showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              width: 156,
                              child: SearchableDropdown.single(
                                icon: null,
                                displayClearIcon: false,
                                selectedValueWidgetFn: (value) {
                                  return Container(
                                    height: 128,width: 128,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(value),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  );
                                },
                                underline: Container(
                                  color: Theme.of(context).primaryColor,
                                ),
                                iconSize: 36,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                                items: widget.settings.binanceTicker.keys
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _priceUnit,
                                hint: "Select a coin",
                                searchHint: "Select a coin",
                                onChanged: (value) {
                                  setState(() {
                                    //_formKey.currentState.validate();
                                    _priceUnit = value;
                                    _priceValue = widget
                                        .SettingsApp.binanceTicker[_priceUnit];
                                  });
                                },
                                isExpanded: true,
                              ),
                            ),
                          );
                        },
                      );*/
                    },
                    child: Text(
                      _priceUnit,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 24,
                        fontWeight: FontWeight.w100,
                        color: Colors.black.withOpacity(0.6),
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 10,
                            color: Color.fromARGB(10, 0, 0, 0),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        widget.user.balance!=null?Container(
            height: 200,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              margin: EdgeInsets.only(top: 0, left: 16, bottom: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.user.balance.balances.length,
                        itemBuilder: (context, index) {
                          /*print(
                              "result: ${widget.settings.binanceTicker["${widget.user.balance.balances[index].asset}${_priceUnit}"]}");*/
                          double _priceValue = 1;
                          _priceValue=widget.settings.binanceTicker["${widget.user.balance.balances[index].asset}${_priceUnit}"]??1;
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
                                  left: widget.user.userTotalExpendingAmount
                                          .containsKey(widget.user.balance
                                              .balances[index].asset)
                                      ? BorderSide(
                                          width: 8,
                                          color: Colors.deepPurple,
                                        )
                                      : BorderSide(
                                          width: 0.0,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 4, left: 16, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(
                                      widget.user.balance.balances[index].asset,
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 24,
                                          //fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.user.balance.balances[index].free.toStringAsPrecision(6)} ${widget.user.balance.balances[index].asset}",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Text(
                                          "${(widget.user.balance.balances[index].free * _priceValue).toStringAsPrecision(6)} ${_priceUnit}")
                                    ],
                                  ),
                                  Container(
                                    width: 8,
                                  )
                                ],
                              ),
                            ),
                            /*secondaryActions: [
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
                                            widget.user.userData.orders.values.toList()[index],
                                            widget.user.firebasUser.uid);
                                      });
                                },
                              )
                            ],*/
                          );
                        }),
                  )
                ],
              ),
            )):Center(child: CircularProgressIndicatorMy(),)
      ],
    );
  }
/*
  Widget BuyOrderCard(int index) {
    return GestureDetector(
      onLongPress: () {
        */ /*showDialog<void>(
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
          );*/ /*
      },
      onTap: () {
        */ /*Firestore.instance
              .collection("users")
              .doc("userTest")
              .collection("orders")
              .doc(widget.querySnapshot.documents[index].documentID)
              .update({
            "active":
            !(widget.querySnapshot.documents[index].data["active"] as bool)
          });*/ /*
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
  }*/
}
