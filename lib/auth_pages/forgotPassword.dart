import 'package:bitcoin_cost_average/controllers/connectivityController.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_cost_average/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../contants.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({
    Key key,
    @required this.authPageController,
    @required this.authScaffoldKey,
    @required this.networkErrorSnackBar,
  }) : super(key: key);

  final PageController authPageController;
  final GlobalKey<ScaffoldState> authScaffoldKey;
  final SnackBar networkErrorSnackBar;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailTextField = TextEditingController();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  var authController = Get.find<AuthController>();
  var connectivityController = Get.find<ConnectivityController>();

  // Run Action When Loading
  bool loading = false;

  // Email Sent SnackBar
  SnackBar emailSent = SnackBar(
    backgroundColor: Color(0xFF0CE8CE),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.email,
          size: 15,
          color: Color(0xFF1C2028),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          "email_sent".tr,
          style: TextStyle(
            color: Color(0xFF1C2028),
          ),
        )
      ],
    ),
  );

  // Map For Displaying Error Messages
  Map<String, String> errorMessage = {
    "email": "",
    "password": "",
    "network": "",
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "forgot_pass".tr,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "forgot_pass_text".tr,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _forgotPasswordFormKey,
            child: TextFormField(
              controller: emailTextField,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Theme.of(context).accentColor,
              obscureText: false,
              //style: Theme.of(context).textTheme.headline5,
              decoration: InputDecoration(labelText: "Email".tr),
              validator: (email) {
                if (email.isEmpty) {
                  return "enter_email".tr;
                } else if (email.contains("@") == false) {
                  return "invalid_email".tr;
                } else if (errorMessage["email"].isNotEmpty) {
                  return errorMessage["email"];
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 30),

          // Send Email Button
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                if (!connectivityController.isOffline()) {
                  setState(() {
                    errorMessage["email"] = "";
                    errorMessage["network"] = "";
                    errorMessage["password"] = "";
                  });

                  // 1. Check Form Validation
                  // 2. Set State "loading" = true
                  // 3. Call "forgotPassword" Future inside AuthService()
                  // 4. Catch NetworkError - Show SnackBar
                  // 5. Set State "errorMessage" = value
                  // 6. Check Form Validation Again
                  // 7. If Valid => Sign In
                  if (!_forgotPasswordFormKey.currentState.validate()) {
                    return;
                  }
                  setState(() {
                    loading = true;
                  });
                  authController.recover(emailTextField.text);
                  setState(() {
                    loading = false;
                  });
                } else {
                  callErrorSnackbar("sorry".tr, "no_connection".tr);
                }
              },
              child: loading
                  ? Container(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).scaffoldBackgroundColor),
                      ),
                    )
                  : Text("Send".tr),
            ),
          ),
        ],
      ),
    );
  }
}
