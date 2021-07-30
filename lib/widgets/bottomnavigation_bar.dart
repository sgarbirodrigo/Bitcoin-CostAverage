import 'package:Bit.Me/controllers/connectivityController.dart';
import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:Bit.Me/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import '../CreateEditOrder.dart';
import '../contants.dart';

class MyBottomNavigationBar extends StatelessWidget {
  var homeController = Get.find<HomeController>();
  var connectivityController = Get.find<ConnectivityController>();
  var userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return TitledBottomNavigationBar(
        currentIndex: homeController.pageIndex.value,
        reverse: true,
        onTap: (index) {
          homeController.setPage(index);
        },
        items: [
          TitledNavigationBarItem(
            title: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple),
            ),
            icon: ElevatedButton(
              onPressed: () async {
                if (!connectivityController.isOffline()) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(child: CreateEditOrder());
                    },
                  );
                  userController.refreshUserData();
                } else {
                  callErrorSnackbar("Sorry :\'(", "No internet connection.");
                }
              },
              child: Icon(
                Icons.add,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          TitledNavigationBarItem(
            title: Text('Home'),
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
          ),
          TitledNavigationBarItem(
            title: Text('Orders'),
            icon: Icon(
              Icons.list_alt_sharp,
              color: Colors.grey,
            ),
          ),
          TitledNavigationBarItem(
            title: Text('Settings'),
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.grey,
            ),
          ),
        ]);
  }
}
