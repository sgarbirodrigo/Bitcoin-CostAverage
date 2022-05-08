import 'dart:convert';
import 'dart:io';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/external/binance_api.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/external/qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
/*
class ExchangeSettingsController extends GetxController {
  var privatekey = "".obs;
  var publickey = "".obs;
  var _exchanges = ["Binance"].obs;
  var _selectedExchange = "".obs;
  var _readingQRCode = false.obs;
  var _selectedStatus = 0.obs;

  var userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    _selectedExchange = _exchanges[0].obs;
    privatekey.value = userController.user.private_key;
    publickey.value = userController.user.public_key;
  }

  @override
  void onClose() {
    print("close");
  }

  @override
  void onReady() {
    print("ready");
  }
}*/

class ExchangeSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExchangeSettingsPageState();
  }
}

class ExchangeSettingsPageState extends State<ExchangeSettingsPage> {
  List<String> _exchanges = ["Binance"];
  String _selectedExchange = "";
  bool _readingQRCode = false;
  int _selectedStatus = 0;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var userController = Get.find<UserController>();

  //var settingsController = Get.put(ExchangeSettingsController());
  TextEditingController privatekey_controller;
  TextEditingController publickey_controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    privatekey_controller = TextEditingController();
    publickey_controller = TextEditingController();
    privatekey_controller.text = userController.user.private_key;
    publickey_controller.text =  userController.user.public_key;
    _selectedExchange= _exchanges[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Color(0xff553277),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                //height: 680,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            child: Platform.isIOS
                                ? IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_outlined,
                                      //color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                  )
                                : Container(),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 32,
                              right: 32,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "selected_exchange".tr,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                  //width: 128,
                                  child: DropdownButton<String>(
                                    value: _selectedExchange,
                                    items: _exchanges.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedExchange = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 64,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        height: MediaQuery.of(context).size.width * 0.7,
                        width: MediaQuery.of(context).size.width * 0.7,
                        //padding: EdgeInsets.only(bottom: ),
                        child: _readingQRCode
                            ? QRViewExample((Barcode barcode) {
                                try {
                                  Map<String, dynamic> response = jsonDecode(barcode.code);
                                  print("response: $response");
                                  if (response["apiKey"] != null && response["secretKey"] != null) {
                                    setState(() {
                                      publickey_controller.text = response["apiKey"];
                                      // settingsController.publickey = response["apiKey"];
                                      privatekey_controller.text = response["secretKey"];
                                      //settingsController.privatekey = response["secretKey"];
                                      _readingQRCode = false;
                                    });
                                  } else {
                                    print("invalid QRCODE");
                                    //todo add snackbar invalid qrcode
                                  }
                                } catch (e) {
                                  print("invalid QRCODE ${e}");
                                  //todo add snackbar invalid qrcode
                                }
                              })
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 64),
                                child: Image.asset('assets/images/link.png'),
                              ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "tip_create_exclusive_account".tr,
                          style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'title'.tr,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          //initialValue: settingsController.publickey,
                          controller: publickey_controller,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.public),
                              labelText: "api_key".tr),
                          onChanged: (value) {
                            //publickey_controller.text = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_value'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          //initialValue: settingsController.privatekey,
                          controller: privatekey_controller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outlined),
                              labelText: "secret_key".tr),
                          onChanged: (value) {
                            //privatekey_controller.text = value;
                          },
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_value'.tr;
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
                            Text("readQR".tr)
                          ],
                        ),
                      ),
                      Container(
                        height: 8,
                      ),
                      GestureDetector(
                        child: Text(
                          'get_API_keys'.tr,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        ),
                        onTap: () {
                          launch('https://www.binance.com/en/my/SettingsApp/api-management');
                        },
                      ),
                      Container(
                        height: 8,
                      ),
                      ElevatedButton(
                        child: Container(
                          /*padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 24),*/
                          child: _selectedStatus == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Text(
                                    "${"save".tr}".toUpperCase(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              : _selectedStatus == 1
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 8, bottom: 8, top: 8, right: 8),
                                          child: Text(
                                            "${"saving".tr}".toUpperCase(),
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 8, bottom: 8, top: 8, right: 4),
                                          child: Text("${"saved".tr}".toUpperCase(),
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                        Container(
                                          height: 32,
                                          width: 16,
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
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                      privatekey_controller.text, publickey_controller.text)) {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(userController.user.uid)
                                        .update({
                                      "private_key": privatekey_controller.text,
                                      "public_key": publickey_controller.text,
                                      "lastUpdatedTimestamp": Timestamp.now()
                                    }).then((value) {
                                      setState(() {
                                        _selectedStatus = 2;
                                      });
                                      Future.delayed(const Duration(milliseconds: 4000), () {
                                        setState(() {
                                          _selectedStatus = 0;
                                        });
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      _selectedStatus = 0;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "api_invalid".tr,
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
                ),
              ),
            ),
          ),
        ));
  }
}
