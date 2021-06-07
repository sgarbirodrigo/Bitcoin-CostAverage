import 'package:bitbybit/binance_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DialogConfig extends StatefulWidget {
  DialogConfig(this.userUid);

  String userUid;

  @override
  State<StatefulWidget> createState() {
    return DialogConfigState();
  }
}

class DialogConfigState extends State<DialogConfig> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: FutureBuilder(
          future: Firestore.instance
              .collection("users")
              .document(widget.userUid)
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
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'To ensure another level of security on your funds, create an account on ',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Binance',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  ' exclusively for automating your daily trades with '),
                          TextSpan(
                            text: 'BitMe',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
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
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Make sure to check your keys, otherwise we won\'t be able to automatically execute your trades.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Row(
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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var response = await getBinanceBalance(
                                    widget.userUid,
                                    publickey_controller.text,
                                    privatekey_controller.text);

                                if (response != null) {
                                  Firestore.instance
                                      .collection("users")
                                      .document(widget.userUid)
                                      .updateData({
                                    "private_key": privatekey_controller.text,
                                    "public_key": publickey_controller.text,
                                    "lastUpdatedTimestamp": Timestamp.now()
                                  }).then((value) {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  print("verify your private keys");
                                }
                              }
                            },
                            child: Text("UPDATE"))
                      ],
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
      ),
    );
  }
}
