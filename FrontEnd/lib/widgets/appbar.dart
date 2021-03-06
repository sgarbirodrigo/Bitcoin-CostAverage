import 'package:bitcoin_cost_average/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/*class AppBarBitMe extends StatefulWidget implements PreferredSizeWidget{
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

}*/
class AppBarBitMe extends StatelessWidget implements PreferredSizeWidget {
  final bool returnIcon;

  AppBarBitMe({this.returnIcon = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery
            .of(context)
            .padding
            .top),
        child: Stack(children: [
          Center(
            child: Text(
              "Bitcoin-Cost Average",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: this.returnIcon
                ? IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
                : Icon(null),),
          /*Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: Icon(
                  Icons.stacked_line_chart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>StockToFlowChart()
                    ),
                  );
                },
              )),*/
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () => Get.find<AuthController>().signOut(),
              )),

          /*Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: GestureDetector(onTap: (){},child: Column(children: [Icon(Icons.add,color: Colors.white,),Text("New Order")],),),
          ),*/
        ]),
        decoration: BoxDecoration(
            gradient: RadialGradient(radius: 6, center: Alignment.centerRight, colors: [
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
      preferredSize: Size(MediaQuery
          .of(context)
          .size
          .width, 54.0),
    );
  }
}
