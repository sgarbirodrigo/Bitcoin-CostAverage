import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularProgressIndicatorMy extends StatefulWidget {
  Color color;

  CircularProgressIndicatorMy({this.color});

  @override
  State<StatefulWidget> createState() {
    return _CircularProgressIndicatorMyState();
  }
}

class _CircularProgressIndicatorMyState
    extends State<CircularProgressIndicatorMy> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS || Platform.isMacOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }
}
