import 'package:bitcoin_cost_average/models/order_model.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:bitcoin_cost_average/widgets/circular_progress_indicator.dart';
import 'package:bitcoin_cost_average/widgets/weekindicator_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'CustomKeyboard.dart';
import 'controllers/user_controller.dart';
import 'external/BinanceSymbolModel.dart';
import 'models/schedule_model.dart';
import 'models/user_model.dart';

class CreateEditOrder extends StatefulWidget {
  CreateEditOrder({this.orderItem});

  OrderItem orderItem;

  @override
  State<StatefulWidget> createState() {
    return CreateEditOrderState();
  }
}

class CreateEditOrderState extends State<CreateEditOrder> {
  String _selectedPair;
  Map<String, BinanceSymbol> listOfSymbols;
  TextEditingController _amountController = TextEditingController();
  Schedule schedule;
  var userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  List<String> pairs;

  bool validatePairString(String pair) {
    if (pair == null) {
      return false;
    }
    if (pair.isEmpty) {
      return false;
    }
    return true;
  }

  Future<List<String>> fetchBinancePairList() async {
    final response = await http.get(Uri.https("api.binance.com", "api/v3/exchangeInfo"));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response);
      List symbols = jsonDecode(response.body)["symbols"];
      listOfSymbols = Map();
      symbols.forEach((element) {
        listOfSymbols[BinanceSymbol.fromJson(element).symbol] = BinanceSymbol.fromJson(element);
      });
      this.pairs = List();
      listOfSymbols.keys.forEach((element) {
        this.pairs.add(listOfSymbols[element].mySymbol);
      });
      onChangeCoin(this.pairs[0]);
      setState(() {});
    } else {
      throw Exception('Failed to load pairs');
    }
  }

  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.orderItem != null) {
      _amountController.text = widget.orderItem.amount.toString();
      this.schedule = widget.orderItem.schedule;
    } else {
      _amountController.text = 0.toString();
      this.schedule = Schedule();
    }
    fetchBinancePairList();
  }

  @override
  Widget build(BuildContext context) {
    double _selectedAmount = 0;
    return SafeArea(
      child: this.pairs != null && this.pairs.isNotEmpty
          ? Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /*IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close_sharp)),*/
Container(width: 8,),
                      widget.orderItem != null
                          ? ElevatedButton(
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
                                            Text('Are you sure you want to delete this order?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Confirm'),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(userController.user.uid)
                                                .update({
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
                                userController.refreshUserData();
                              },
                              child: Text("DELETE"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.red)),
                            )
                          : Container(),
                      widget.orderItem == null
                          ? Expanded(
                          child: SearchableDropdown.single(
                            icon: null,
                            displayClearIcon: false,
                            selectedValueWidgetFn: (value) {
                              return Row(
                                children: [
                                  Text(
                                    value,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 36,
                                  ),
                                ],
                              );
                            },
                            underline: Container(
                              color: Theme.of(context).primaryColor,
                            ),
                            iconSize: 36,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                            items: this.pairs.map((String value) {
                              //print("value-data: $value");
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
                                onChangeCoin(value);
                              });
                            },
                            isExpanded: false,
                          ))
                          : Expanded(
                        child: Container(
                          //color: Colors.red,
                          padding: EdgeInsets.only(top: 8, bottom: 16),
                          child: Center(child: Text(widget.orderItem.pair, style: TextStyle(fontSize: 24)),),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (widget.orderItem == null) {
                              OrderItem newOrder = OrderItem(
                                active: true,
                                amount: _selectedAmount,
                                exchange: "Binance",
                                pair: _selectedPair,
                                schedule: this.schedule,
                                createdTimestamp: Timestamp.now(),
                              );
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(userController.user.uid)
                                  .update({
                                "orders.${newOrder.pair.replaceAll("/", "_")}": newOrder.toJson()
                              }).then((value) {
                                Navigator.pop(context);
                              });
                            } else {
                              widget.orderItem.updatedTimestamp = Timestamp.now();
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(userController.user.uid)
                                  .update({
                                "orders.${widget.orderItem.pair.replaceAll("/", "_")}":
                                    widget.orderItem.toJson()
                              }).then((value) {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        child: Text(widget.orderItem == null ? "CREATE" : "UPDATE"),
                      ),
                      Container(
                        width: 12,
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.only(top: 16),
                    child: TextFormField(
                      showCursor: true,
                      //readOnly: widget.orderItem == null,
                      //enabled: widget.orderItem == null,
                      //readOnly: true,
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          isDense: true,
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          suffix: Text(
                            validatePairString(_selectedPair) ? _selectedPair.split("/")[1] : "",
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          //hintText: "Amount",
                          labelText: "Amount to invest",
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                          )),
                      keyboardType: CustomNumberKeyboard.inputType,
                      /*keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                      ],*/
                      onChanged: (value) {
                        /*_amountController.text = value.replaceAll(",", ".");
                        if (_amountController.text.contains(".")) {
                          _amountController.text =
                              "${_amountController.text.split(".")[0]}.${_amountController.text.split(".")[1]}";
                        }
                        _amountController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _amountController.text.length));*/
                      },
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        try {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some value';
                          }
                          if (validatePairString(_selectedPair)) {
                            double valueDouble = double.parse(value.replaceAll(",", "."));
                            double minDouble = double.parse(
                                listOfSymbols[_selectedPair.toString().replaceAll("/", "")]
                                    .filters[3]
                                    .minNotional
                                    .toString());
                            if (valueDouble < minDouble) {
                              return 'Must be bigger than the minimum amount';
                            }
                          }
                          _selectedAmount = double.parse(value.replaceAll(",", "."));
                          return null;
                        } catch (e) {
                          return "Invalid number";
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    validatePairString(_selectedPair)
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
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      double.parse(_amountController.text) >= 0 && validatePairString(_selectedPair)
                          ? "Weekly expense: ${returnCurrencyCorrectedNumber(_selectedPair.split("/")[1], double.parse(_amountController.text) * this.schedule.getMultiplier())}"
                          : "Weekly expense: ...",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 128,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicatorMy(),
                    Container(
                      height: 16,
                    ),
                    Text(widget.orderItem != null ? "Loading..." : "Loading available pairs...")
                  ],
                ),
              ),
            ),
    );
  }

  void onChangeCoin(String value) {
    _selectedPair = value;
    _amountController.text = listOfSymbols[_selectedPair.toString().replaceAll("/", "")]
        .filters[3]
        .minNotional
        .toString();
    CustomNumberKeyboard.setMinimumAmount(
        listOfSymbols[_selectedPair.toString().replaceAll("/", "")].filters[3].minNotional);
  }
}
