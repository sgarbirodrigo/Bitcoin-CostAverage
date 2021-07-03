import 'dart:convert';
import 'package:Bit.Me/external/qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../external/binance_api.dart';
import '../models/user_model.dart';

class ConnectToBinancePage extends StatefulWidget {
  UserManager user;

  ConnectToBinancePage(this.user);

  @override
  State<StatefulWidget> createState() {
    return _ConnectToBinancePageState();
  }
}

class _ConnectToBinancePageState extends State<ConnectToBinancePage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final _formKey = GlobalKey<FormState>();
  int _selectedStatus = 0;
  bool _readingQRCode = false;
  TextEditingController privatekey_controller;
  TextEditingController publickey_controller;

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/introduction/$assetName', width: width);
  }

  @override
  void initState() {
    privatekey_controller = TextEditingController();
    publickey_controller = TextEditingController();
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.firebaseUser.uid)
        .get()
        .then((DocumentSnapshot userSnapshot) {
      if (userSnapshot.data() != null) {
        publickey_controller.text = UserData.fromJson(userSnapshot.data()).public_key;
      }
      if (userSnapshot.data() != null) {
        privatekey_controller.text = UserData.fromJson(userSnapshot.data()).private_key;
      }
    });
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    const Color col = Colors.white;
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: col,
      imagePadding: EdgeInsets.zero,
    );
    print("index $index");
    return IntroductionScreen(
      showNextButton: false,globalBackgroundColor: Colors.white,
      showSkipButton: false,
      //freeze: this.index==4,
      showDoneButton: false,
      dotsDecorator: DotsDecorator(
          size: const Size.square(12.0),
          activeSize: const Size(48.0, 12.0),
          activeColor: Colors.deepPurple,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 2.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
      onChange: (index) {
        this.index = index;
      },
      key: introKey,
      pages: [
        PageViewModel(
          title: "How we work?",
          body:
              "We connect to your Binance account and automatically execute your predefined orders daily at 11PM",
          image: _buildImage(
            'connect.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let\'s connect to Binance",
          body:
              "To connect with your Binance account we need you to generate API keys on Binance website.",
          image: _buildImage(
            'binance.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Creating API key",
          body:
              "After logging into your Binance account, click [API Management] in the user center drop-down box.",
          image: _buildImage(
            'api_1.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Saving API key",
          body:
              "After clicking [Create API], you will see API key and Secret Key, save those keys.\n\nAttention:\nCHECK \"Enable Spot & Margin Trading\"\n UNCHECK \"Enable Withdrawals\"",
          image: _buildImage(
            'api_config.png',
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(top: 32),
            height: 128,
            width: 128,
            //padding: EdgeInsets.only(bottom: ),
            child: _readingQRCode
                ? QRViewExample((Barcode barcode) {
                    try {
                      Map<String, dynamic> response = jsonDecode(barcode.code);
                      if (response["apiKey"] != null &&
                          response["secretKey"] != null) {
                        publickey_controller.text = response["apiKey"];
                        privatekey_controller.text = response["secretKey"];
                        setState(() {
                          _readingQRCode = false;
                        });
                      } else {
                        //todo add snackbar invalid qrcode
                      }
                    } catch (e) {
                      //todo add snackbar invalid qrcode
                    }
                  })
                : Image.asset('assets/images/app_link_binance.png'),
          ),
          useScrollView: true,
          bodyWidget: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                    //height: 520,
                    child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _readingQRCode = !_readingQRCode;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code,
                              color: Colors.white,
                            ),
                            Container(
                              width: 16,
                            ),
                            Text("Read QR Code")
                          ],
                        ),
                      ),
                      Container(
                        height: 8,
                      ),
                      GestureDetector(
                        child: Text(
                          'Get your API keys.',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        ),
                        onTap: () {
                          launch(
                              'https://www.binance.com/en/my/SettingsApp/api-management');
                        },
                      ),
                      Container(
                        height: 16,
                      ),
                      ElevatedButton(
                        child: Container(
                          /*padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 24),*/
                          child: _selectedStatus == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.user.firebaseUser.uid)
                                        .update({
                                      "private_key": privatekey_controller.text,
                                      "public_key": publickey_controller.text,
                                      "hasConnected": true,
                                      "lastUpdatedTimestamp": Timestamp.now()
                                    }).then((value) {
                                      if (mounted)
                                        setState(() {
                                          _selectedStatus = 2;
                                        });
                                      if (mounted) setState(() {});
                                      Future.delayed(
                                          const Duration(milliseconds: 4000),
                                          () {
                                        setState(() {
                                          _selectedStatus = 0;
                                        });
                                      });
                                    });
                                    widget.user.updateUser();
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
                )),
              )),
          /*image: _buildImage(
            'connect.png',
          ),*/
          decoration: pageDecoration,
        ),
      ],
    );
  }
}
