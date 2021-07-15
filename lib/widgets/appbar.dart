import 'package:Bit.Me/controllers/auth_controller.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/purchase/paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppBarBitMe extends StatefulWidget implements PreferredSizeWidget{
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final bool returnIcon;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight*0.8);
  const AppBarBitMe({this.scaffoldKey, this.title, this.returnIcon=false});
  @override
  State<StatefulWidget> createState() {
    return _AppBarBitMeState();
  }

}
class _AppBarBitMeState extends State<AppBarBitMe> {
  var authController = Get.find<AuthController>();
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
            child: widget.returnIcon?IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ): Icon(null)),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child:IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () => authController.signOut(),
              )
          ),

          /*Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: GestureDetector(onTap: (){},child: Column(children: [Icon(Icons.add,color: Colors.white,),Text("New Order")],),),
          ),*/
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