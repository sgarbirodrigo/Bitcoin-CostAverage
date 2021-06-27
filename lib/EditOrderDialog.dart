import 'package:Bit.Me/external/BinanceSymbolModel.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/weekindicator_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/order_model.dart';
import 'models/schedule_model.dart';
import 'models/user_model.dart';

class EditOrderDialog extends StatefulWidget {
  OrderItem orderItem;
  User user;

  EditOrderDialog(this.orderItem, this.user);

  @override
  State<StatefulWidget> createState() {
    return EditOrderDialogState();
  }
}

class EditOrderDialogState extends State<EditOrderDialog> {
  Map<String, BinanceSymbol> listOfSymbols;

  //double _selectedAmount = 0;
  //bool _state;
  TextEditingController _amountController = TextEditingController();

  Future<List<String>> fetchBinancePairList() async {
    final response =
        await http.get(Uri.https("api.binance.com", "api/v3/exchangeInfo"));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON._state
      //print(response);
      List symbols = jsonDecode(response.body)["symbols"];
      listOfSymbols = Map();
      symbols.forEach((element) {
        listOfSymbols[BinanceSymbol.fromJson(element).symbol] =
            BinanceSymbol.fromJson(element);
      });
      List<String> pairs = List();
      listOfSymbols.keys.forEach((element) {
        pairs.add(listOfSymbols[element].mySymbol);
      });
      return pairs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load pairs');
    }
  }

  @override
  void initState() {
    _amountController.text = widget.orderItem.amount.toString();
    /* _amountController.addListener(() {
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    //_amountController.text = _selectedAmount.toString();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: FutureBuilder(
        future: fetchBinancePairList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> pair) {
          if (pair.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Center(
                            child: Container(
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(widget.orderItem.pair,
                              style: TextStyle(fontSize: 24)),
                        )),
                        Positioned(
                          left: 4,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            height: 92,
                            //color: Colors.red,
                            width: 64,
                            child: CupertinoSwitch(
                                activeColor: Theme.of(context).primaryColor,
                                value: widget.orderItem.active,
                                onChanged: (state) {
                                  setState(() {
                                    widget.orderItem.active = state;
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 128,
                        padding: EdgeInsets.only(
                          top: 16,
                        ),
                        child: TextFormField(
                          controller: _amountController,
                          decoration: InputDecoration(
                              isDense: true,
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 0, minHeight: 0),
                              suffix: Text(
                                widget.orderItem.pair.split("/")[1],
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              //hintText: "Amount",
                              labelText: "Amount",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.0),
                              )),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            //FilteringTextInputFormatter.allow(filterPattern)
                          ],
                          onChanged: (value) {
                            _amountController.text = value.replaceAll(",", ".");

                            if (_amountController.text.contains(".")) {
                              _amountController.text =
                                  "${_amountController.text.split(".")[0]}.${_amountController.text.split(".")[1]}";
                            }
                            _amountController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _amountController.text.length));
                          },
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some value';
                            }
                            double valueDouble = double.parse(value);
                            double minDouble = double.parse(listOfSymbols[widget
                                    .orderItem.pair
                                    .toString()
                                    .replaceAll("/", "")]
                                .filters[3]
                                .minNotional
                                .toString());
                            if (valueDouble < minDouble) {
                              return 'Must be bigger than the minimum amount';
                            }

                            _amountController.text =
                                double.parse(value).toString();
                            widget.orderItem.amount =
                                double.parse(_amountController.text);
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      )
                    ],
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    "Minimum amount: ${listOfSymbols[widget.orderItem.pair.toString().replaceAll("/", "")].filters[3].minNotional.toString()} ${widget.orderItem.pair.split("/")[1]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    height: 36,
                    width: 256,
                    child: WeekIndicatorEditor(widget.orderItem.schedule,
                        (schedule) {
                      setState(() {
                        widget.orderItem.schedule = schedule;
                      });
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                    child: Text(
                      double.parse(_amountController.text) >= 0
                          ? "Weekly expense: ${doubleToValueString(double.parse(_amountController.text) * widget.orderItem.schedule.getMultiplier())} ${widget.orderItem.pair.split("/")[1]}"
                          : "Weekly expense: ...",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String result = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete order'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            'Are you sure you want to delete this order?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Confirm'),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection("users")
                                            .document(
                                                widget.user.firebaseUser.uid)
                                            .updateData({
                                          "orders.${widget.orderItem.pair.replaceAll("/", "_")}":
                                              FieldValue.delete()
                                        }).then((value) {
                                          Navigator.of(context).pop("deleted");
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop("canceled");
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result == "deleted") {
                              Navigator.of(context).pop();
                            }
                            widget.user.updateUser();
                          },
                          child: Text("DELETE"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              widget.orderItem.updatedTimestamp =
                                  Timestamp.now();
                              Firestore.instance
                                  .collection("users")
                                  .document(widget.user.firebaseUser.uid)
                                  .updateData({
                                "orders.${widget.orderItem.pair.replaceAll("/", "_")}":
                                    widget.orderItem.toJson()
                              }).then((value) {
                                Navigator.pop(context);
                              });
                              //print("validate");
                            }
                          },
                          child: Text("UPDATE"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container(
            height: 64,
            width: 64,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
