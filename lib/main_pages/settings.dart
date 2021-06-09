import 'package:bitbybit/external/binance_api.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  User user;

  SettingsPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> _status = ["normal", "saving", "saved"];
  int _selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: FutureBuilder(
        future: Firestore.instance
            .collection("users")
            .document(widget.user.firebasUser.uid)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot userSnapshot = snapshot.data;
            TextEditingController privatekey_controller =
                TextEditingController();
            TextEditingController publickey_controller =
                TextEditingController();
            if (userSnapshot.data != null) {
              publickey_controller.text = userSnapshot.data["public_key"];
            }
            if (userSnapshot.data != null) {
              privatekey_controller.text = userSnapshot.data["private_key"];
            }
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 300,
                    //padding: EdgeInsets.only(bottom: ),
                    child: Image.asset('assets/images/app_link_binance.png'),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'To ensure another level of security on your funds, create an account on ',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Binance',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                                ' exclusively for automating your daily trades with '),
                        TextSpan(
                          text: 'BitMe',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: TextFormField(
                      controller: publickey_controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.public),
                          labelText: "Public Key"),
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some value';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: TextFormField(
                      controller: privatekey_controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outlined),
                          labelText: "Private Key"),
                      onChanged: (value) {},
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some value';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  GestureDetector(
                    child: Text(
                      'Get your API keys.',
                      style: TextStyle(color: Colors.deepPurple,decoration: TextDecoration.underline,fontSize: 16),
                    ),
                    onTap: () {
                      launch(
                          'https://www.binance.com/en/my/settings/api-management');
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ElevatedButton(
                    child: Container(
                      /*padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 24),*/
                      child: _selectedStatus == 0
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 24),
                              child: Text(
                                "SAVE",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : _selectedStatus == 1
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 32,
                                          bottom: 24,
                                          top: 24,
                                          right: 24),
                                      child: Text(
                                        "SAVING",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 32,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.grey),
                                      ),
                                    ),
                                    Container(
                                      width: 16,
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 32,
                                          bottom: 24,
                                          top: 24,
                                          right: 16),
                                      child: Text("SAVED",
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 32,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.grey,
                                        size: 32,
                                      ),
                                    ),
                                    Container(
                                      width: 8,
                                    )
                                  ],
                                ),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                      /*side:
                                        BorderSide(color: Colors.deepPurple)*/
                    ))),
                    onPressed: _selectedStatus != 0
                        ? null
                        : () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _selectedStatus = 1;
                              });
                              // print("${_selectedStatus}");
                              if (await areUserKeysNewCorrect(
                                  privatekey_controller.text,
                                  publickey_controller.text)) {
                                Firestore.instance
                                    .collection("users")
                                    .document(widget.user.firebasUser.uid)
                                    .updateData({
                                  "private_key": privatekey_controller.text,
                                  "public_key": publickey_controller.text,
                                  "lastUpdatedTimestamp": Timestamp.now()
                                }).then((value) {
                                  setState(() {
                                    _selectedStatus = 2;
                                  });
                                  setState(() {});
                                  Future.delayed(
                                      const Duration(milliseconds: 4000), () {
                                    setState(() {
                                      _selectedStatus = 0;
                                    });
                                  });
                                });
                              } else {
                                setState(() {
                                  _selectedStatus = 0;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(new SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "API keys invalid!",
                                    textAlign: TextAlign.left,
                                  ),
                                  duration: Duration(seconds: 4),
                                  behavior: SnackBarBehavior.fixed,
                                  /* action: SnackBarAction(
                                      label: 'OK',
                                      textColor: Colors.yellow,
                                      onPressed: () {
                                        //  Navigator.of(context).pop();
                                      },

                                    )*/
                                ));
                              }
                            }
                          },
                  )
                ],
              ),
            );
          } else {
            return Container(
              height: 64,
              width: 64,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    ));
  }
}
