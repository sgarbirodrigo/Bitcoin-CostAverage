import 'package:bitbybit/BinanceSymbolModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditOrderDialog extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  String userUid;
  EditOrderDialog(DocumentSnapshot this.documentSnapshot,this.userUid);

  @override
  State<StatefulWidget> createState() {
    return EditOrderDialogState();
  }
}

class EditOrderDialogState extends State<EditOrderDialog> {
  Map<String, BinanceSymbol> listOfSymbols;
  String _selectedText;
  double _selectedAmount = 0;
  bool _state;

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
    _selectedText = widget.documentSnapshot.data["pair"];
    _selectedAmount =
        double.parse(widget.documentSnapshot.data["amount"].toString());
    _state = widget.documentSnapshot.data["active"];
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _amountController = TextEditingController();
    _amountController.text = _selectedAmount.toString();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: FutureBuilder(
        future: fetchBinancePairList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> pair) {
          if (pair.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(_selectedText,
                                style: TextStyle(fontSize: 24)),
                          )
                          /*SearchableDropdown.single(
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
                              color: Colors.blue,
                            ),
                            iconSize: 36,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                            items: pair.data.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: _selectedText,
                            hint: "Select a pair",
                            searchHint: "Select a pair",
                            onChanged: (value) {
                              setState(() {
                                //_formKey.currentState.validate();
                                _selectedText = value;
                                print(listOfSymbols.keys.toString());
                              });
                            },
                            isExpanded: true,
                          )*/
                          ,
                        ),
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
                                value: _state,
                                onChanged: (state) {
                                  setState(() {
                                    _state = state;
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
                                _selectedText.split("/")[1],
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
                              _amountController.text = "${_amountController.text.split(".")[0]}.${_amountController.text.split(".")[1]}";
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
                            if (_selectedText != null) {
                              if (_selectedText.isNotEmpty) {
                                double valueDouble = double.parse(value);
                                double minDouble = double.parse(listOfSymbols[
                                        _selectedText
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
                            _selectedAmount = double.parse(value);
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
                    _selectedText.isNotEmpty
                        ? "Minimum amount: ${listOfSymbols[_selectedText.toString().replaceAll("/", "")].filters[3].minNotional.toString()} ${_selectedText.split("/")[1]}"
                        : "Minimum Amount: ...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                           String result = await showDialog<String>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
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
                                        Firestore.instance
                                            .collection("users")
                                            .document(widget.userUid)
                                            .collection("orders")
                                            .document(widget.documentSnapshot.documentID)
                                            .delete();
                                        Navigator.of(context).pop("deleted");
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
                           if(result == "deleted"){
                             Navigator.of(context).pop();
                           }
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
                              Firestore.instance
                                  .collection("users")
                                  .document(widget.userUid)
                                  .collection("orders")
                                  .document(widget.documentSnapshot.documentID)
                                  .updateData({
                                "active": _state,
                                "amount": _selectedAmount,
                                //"exchange": "binance",
                                //"pair": _selectedText,
                                //"user": userUid,
                                "updatedTimestamp": Timestamp.now()
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
