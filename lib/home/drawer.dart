import 'package:bitbybit/home.dart';
import 'package:bitbybit/main_pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../external/authService.dart';

class DrawerBitMe extends StatefulWidget {
  final FirebaseUser user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(Section section) onPageChange;
  const DrawerBitMe({Key key, this.user, this.scaffoldKey, this.onPageChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DrawerBitMeState();
  }
}

class _DrawerBitMeState extends State<DrawerBitMe> {
  int _selectedDestination = 0;
  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    TextStyle _drawerItemStyle = TextStyle(
        /*color: Colors.deepPurple,*/
        fontSize: 18);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;


    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: SafeArea(child: Column(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffF9F8FD),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    //padding: EdgeInsets.only(bottom: 8),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.deepPurple),
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Colors.deepPurple,
            ),
            title: Text(
              'Dashboard',
              style: _drawerItemStyle,
            ),
            onTap: () {
              widget.onPageChange(Section.DASHBOARD);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star_border_outlined,
              color: Colors.deepPurple,
            ),
            title: Text('Orders', style: _drawerItemStyle),
            onTap: () {
              widget.onPageChange(Section.ORDERS);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Colors.deepPurple,
            ),
            title: Text('History', style: _drawerItemStyle),
            onTap: () {
              widget.onPageChange(Section.HISTORY);
              Navigator.pop(context);
            },
          ),
          Expanded(child: Container()),
          Divider(
            height: 1,
            thickness: 1,
          ),

          //Container(color: Colors.black.withOpacity(0.3),height: 0.5,),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.deepPurple,
            ),
            title: Text('Settings', style: _drawerItemStyle),
            onTap: () {
              widget.onPageChange(Section.SETTINGS);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.deepPurple,
            ),
            title: Text('Logout', style: _drawerItemStyle),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              AuthService().signOut();
            },
          ),
          Container(
            height: 16,
          )
        ],
      ),),
    );

  }
}
