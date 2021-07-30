import 'package:Bit.Me/CreateEditOrder.dart';
import 'package:Bit.Me/controllers/connectivityController.dart';
import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:Bit.Me/main_pages/dashboard_widget/orders_widgets/orders_left_column_widget.dart';
import 'package:Bit.Me/main_pages/dashboard_widget/orders_widgets/orders_right_column_widget.dart';
import 'package:Bit.Me/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../main_pages/pairdetail_page.dart';
import '../charts/line_chart_mean.dart';
import '../contants.dart';
import '../models/user_model.dart';

class OrderItemList extends StatelessWidget {
  var userController = Get.find<UserController>();
  var connectivityController = Get.find<ConnectivityController>();
  int index;

  OrderItemList(this.index);

  @override
  Widget build(BuildContext context) {
    return userController.pairData_items.value != null
        ? Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.2,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PairDetailPage(userController.user.orders.values.toList()[this.index])));
              },
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 8),
                child: Row(
                  children: [
                    OrdersLeftColumnWidget(this.index),
                    Container(
                      width: 16,
                    ),
                    Expanded(
                        child: PriceAVGChartLine(
                            pair: userController.user.orders.values.toList()[this.index].pair)),
                    OrdersRightColumnWidget(this.index),
                  ],
                ),
              ),
            ),
            actions: [
              getChangeActive(
                  userController.pairData_items
                      .value[userController.user.orders.values.toList()[this.index].pair],
                  userController.user.orders.values.toList()[this.index])
            ],
            secondaryActions: userController.pairData_items
                            .value[userController.user.orders.values.toList()[this.index].pair] !=
                        null &&
                    userController
                            .pairData_items
                            .value[userController.user.orders.values.toList()[this.index].pair]
                            .historyItems
                            .length >
                        0
                ? [
                    MyIconActionEdit(this.index),
                    IconSlideAction(
                      iconWidget: Container(
                        color: Colors.deepPurple.shade300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              "History",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PairDetailPage(
                                  userController.user.orders.values.toList()[this.index],
                                )));
                      },
                    ),
                  ]
                : [
                    MyIconActionEdit(this.index),
                  ],
          )
        : Container();
  }

  IconSlideAction MyIconActionEdit(int index) {
    return IconSlideAction(
      iconWidget: Container(
        color: Colors.deepPurple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              size: 24,
              color: Colors.white,
            ),
            Text(
              "Edit",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
      onTap: () async {
        if (!connectivityController.isOffline()) {
          await showModalBottomSheet(
            context: Get.context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) => Container(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: CreateEditOrder(
                  orderItem: userController.user.orders.values.toList()[index],
                ),
              ),
            ),
          );
          userController.refreshUserData();
        } else {
          callErrorSnackbar("Sorry :\'(", "No internet connection.");
        }
      },
    );
  }

  bool isActivityChanging = false;

  IconSlideAction getChangeActive(PairData pairData, OrderItem orderItem) {
    bool isActive = orderItem.active;
    return IconSlideAction(
      iconWidget: Container(
        color: isActive ? redAppColor : greenAppColor,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isActivityChanging
                ? Container(
                    height: 16,
                    width: 16,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                  )
                : Icon(
                    isActive ? Icons.pause : Icons.play_arrow_outlined,
                    color: Colors.white,
                  ),
            Container(
              height: 4,
            ),
            Text(
              isActive ? "Pause" : "Activate",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
      onTap: () {
        if (!connectivityController.isOffline()) {
          isActivityChanging = true;
          FirebaseFirestore.instance.collection("users").doc(userController.user.uid).update(
              {"orders.${orderItem.pair.replaceAll("/", "_")}.active": !isActive}).then((value) {
            isActivityChanging = false;
            userController.refreshUserData();
          });
          userController.refreshUserData();
        } else {
          callErrorSnackbar("Sorry :\'(", "No internet connection.");
        }
      },
    );
  }
}
