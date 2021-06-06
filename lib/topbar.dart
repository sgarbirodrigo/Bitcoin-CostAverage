import 'package:bitbybit/dialog_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTopBar extends StatefulWidget {
  MyTopBar(this.userUid);
final String userUid;
  @override
  State<StatefulWidget> createState() {
    return _MyTopBarState();
  }
}

class _MyTopBarState extends State<MyTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "BitMe",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Arial Rounded MT Bold',
                        fontSize: 24,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 10,
                            color: Color.fromARGB(10, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfig(widget.userUid);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
