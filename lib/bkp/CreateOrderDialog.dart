import 'package:Bit.Me/models/order_model.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/weekindicator_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../external/BinanceSymbolModel.dart';
import '../models/schedule_model.dart';
import '../models/user_model.dart';

class CreateOrderDialog extends StatefulWidget {
  User user;

  CreateOrderDialog(this.user);

  @override
  State<StatefulWidget> createState() {
    return CreateOrderDialogState();
  }
}

class CreateOrderDialogState extends State<CreateOrderDialog> {
  String _selectedPair = "BTC/USDT";
  Map<String, BinanceSymbol> listOfSymbols;
  TextEditingController _amountController = TextEditingController();
  Schedule schedule = Schedule();

  Future<List<String>> fetchBinancePairList() async {
    final response =
        await http.get(Uri.https("api.binance.com", "api/v3/exchangeInfo"));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
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
    _amountController.text = 0.toString();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double _selectedAmount = 0;
    return Dialog(
      child: FutureBuilder(
        future: fetchBinancePairList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> pair) {
          if (pair.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: SearchableDropdown.single(
                      icon: null,
                      displayClearIcon: false,
                      selectedValueWidgetFn: (value) {
                        return Container(
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
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      items: pair.data.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: _selectedPair,
                      hint: "Select a pair",
                      searchHint: "Select a pair",
                      onChanged: (value) {
                        setState(() {
                          //_formKey.currentState.validate();
                          _selectedPair = value;
                          print(listOfSymbols.keys.toString());
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    width: 128,
                    padding: EdgeInsets.only(top: 16),
                    child: TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                          isDense: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                          suffix: Text(
                            _selectedPair.split("/")[1],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          //hintText: "Amount",
                          labelText: "Amount to invest",
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
                        if (_selectedPair != null) {
                          if (_selectedPair.isNotEmpty) {
                            double valueDouble =
                                double.parse(value.replaceAll(",", "."));
                            double minDouble = double.parse(listOfSymbols[
                                    _selectedPair
                                        .toString()
                                        .replaceAll("/", "")]
                                .filters[3]
                                .minNotional
                                .toString());
                            if (valueDouble < minDouble) {
                              return 'Must be bigger than the minimum amount';
                            }
                          }
                        }
                        _selectedAmount =
                            double.parse(value.replaceAll(",", "."));
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    _selectedPair.isNotEmpty
                        ? "Minimum amount: ${listOfSymbols[_selectedPair.toString().replaceAll("/", "")].filters[3].minNotional.toString()} ${_selectedPair.split("/")[1]}"
                        : "Minimum Amount: ...",
                    style: TextStyle(color: Colors.black),
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    height: 36,
                    child: WeekIndicatorEditor(this.schedule, (schedule) {
                      setState(() {
                        this.schedule = schedule;
                      });
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                    child: Text(
                      double.parse(_amountController.text) >= 0
                          ? "Weekly expense: ${doubleToValueString(double.parse(_amountController.text) * this.schedule.getMultiplier())} ${_selectedPair.split("/")[1]}"
                          : "Weekly expense: ...",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        Container(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              OrderItem newOrder = OrderItem(
                                active: true,
                                amount: _selectedAmount,
                                exchange: "Binance",
                                pair: _selectedPair,
                                schedule: this.schedule,
                                createdTimestamp: Timestamp.now(),
                              );
                              Firestore.instance
                                  .collection("users")
                                  .document(widget.user.firebaseUser.uid)
                                  .updateData({
                                "orders.${newOrder.pair.replaceAll("/", "_")}":
                                    newOrder.toJson()
                              }).then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text("CREATE"),
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
    /*return AlertDialog(
      title: Text("Create order:"),
      content: ,
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("CREATE"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Firestore.instance
                  .collection("users")
                  .document("userTest")
                  .collection("orders")
                  .add({
                "active": true,
                "amount": _selectedAmount,
                "exchange": "binance",
                "pair": _selectedText,
                "user": "userTest",
                "createdTimestamp":Timestamp.now()
              });
            }
          },
        ),
      ],
    );*/
  }
}
