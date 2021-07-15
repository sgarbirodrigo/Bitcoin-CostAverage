import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularProgressIndicatorMy extends StatefulWidget {
  final Color color;
  final String info;

  CircularProgressIndicatorMy({this.color,this.info});

  @override
  State<StatefulWidget> createState() {
    return _CircularProgressIndicatorMyState();
  }
}

class _CircularProgressIndicatorMyState extends State<CircularProgressIndicatorMy> {
  @override
  Widget build(BuildContext context) {
    print("loading reason: ${widget.info}");
    return Container(
      color: Colors.white,
      child: Center(
        child: Platform.isIOS || Platform.isMacOS
            ? CupertinoActivityIndicator()
            : CircularProgressIndicator(),
      ),
    );
  }
}
