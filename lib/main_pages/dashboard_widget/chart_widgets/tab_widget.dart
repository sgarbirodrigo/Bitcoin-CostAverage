import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../tools.dart';

class ChartTabWidget extends StatelessWidget {
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xffF7F8F9),
        border: Border(
          top: BorderSide(color: Colors.deepPurple, width: 0.5),
        ),
      ),
      child: Center(
        child: Obx(() {
          print("balance: ${userController.balance.value.balancesMapped}");
          return Container(
            //color: Colors.red,
            alignment: Alignment.center,
            //width: ,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userController.userTotalExpendingAmount.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List coins = userController.userTotalExpendingAmount.keys.toList();
                  List<String> openPairs = List();
                  userController.userTotalExpendingAmount.forEach((key, value) {
                    openPairs.add("$key/$value");
                  });
                  return GestureDetector(
                    onTap: () {
                      //widget.settings.updateBaseCoin(coins[index]);
                      String initial = userController.userTotalBuyingAmount.keys
                          .where((element) => element.contains("/${coins[index]}"))
                          .first;
                      //print("pair: $initial");
                      userController.baseCoin.value = initial.split("/")[1];
                      // widget.settings.base_pair_color = colorsList[0];
                    },
                    child: AnimatedContainer(
                      width: 150,
                      //padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        //color: Color(0xffF7F8F9),
                        color: coins[index] == userController.baseCoin.value
                            ? Colors.deepPurple.shade50
                            : Color(0xffF7F8F9),
                        border: coins[index] == userController.baseCoin.value
                            ? Border(
                                top: BorderSide(color: Colors.deepPurple, width: 4),
                                right: BorderSide(color: Colors.black.withOpacity(0.3), width: 0.5),
                                left: BorderSide(color: Colors.black.withOpacity(0.3), width: 0.5))
                            : Border(
                                top: BorderSide(color: Colors.deepPurple, width: 0.5),
                                right: BorderSide(color: Colors.black.withOpacity(0.3), width: 0.5),
                                left: BorderSide(color: Colors.black.withOpacity(0.3), width: 0.5)),
                      ),
                      duration: Duration(milliseconds: 250),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: coins[index] == userController.baseCoin.value ? 4 : 8),
                            child: Text(
                              "${returnCurrencyName(coins[index])}",
                              style:
                                  TextStyle(fontFamily: 'Arial', fontSize: 24, color: Colors.black),
                            ),
                          ),
                          Container(
                            height: 0,
                          ),
                          Visibility(
                            visible: userController.balance.value != null &&
                                userController.balance.value.balancesMapped != null,
                            child: Text(
                              userController.balance.value != null &&
                                      userController.balance.value.balancesMapped != null
                                  ? "${returnCurrencyCorrectedNumber(
                                      coins[index],
                                      userController.balance.value.balancesMapped[coins[index]],
                                    )}"
                                  : "",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            height: 4,
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        }),
      ),
    );
  }
}
