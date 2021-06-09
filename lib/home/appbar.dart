import 'package:bitbybit/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../dialog_config.dart';

class AppBarBitMe extends StatefulWidget implements PreferredSizeWidget{
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User user;
  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight*0.8);
  const AppBarBitMe({Key key, this.scaffoldKey, this.user,this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppBarBitMeState();
  }

}
class _AppBarBitMeState extends State<AppBarBitMe> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(children: [
          Center(
            child: Text(
              widget.title,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.dehaze_rounded,
                color: Colors.white,
              ),
              onPressed: () => widget.scaffoldKey.currentState.openDrawer(),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfig(widget.user);
                    },
                  );
                }),
          ),
        ]),
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 6,
                center: Alignment.centerRight,
                colors: [
                  Color(0xff7544AF),
                  Color(0xff553277),
                ]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[800],
                blurRadius: 16.0,
                spreadRadius: 1.0,
              )
            ]),
      ),
      preferredSize: Size(MediaQuery.of(context).size.width, 54.0),
    );
  }

}