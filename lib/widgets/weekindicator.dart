import 'package:Bit.Me/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../contants.dart';

enum ORDER_STATUS { RUNNING, PAUSED, ERROR }


class WeekIndicator extends StatelessWidget {
  Color _selectedColor;
  TextStyle _selectedTextStyle = TextStyle(color: Colors.white);
  TextStyle _notSelectedTextStyle;
  Color _notSelectedColor;
  double borderRadius = 4;

  final Schedule schedule;
  final ORDER_STATUS order_status;
  
  WeekIndicator(this.schedule,this.order_status){
    switch(order_status){
      case ORDER_STATUS.RUNNING:
        _selectedColor = greenAppColor;
        break;
      case ORDER_STATUS.PAUSED:
        _selectedColor = Colors.grey.withOpacity(0.8);
        break;
      case ORDER_STATUS.ERROR:
        _selectedColor =  redAppColor;
        break;
      default:
        _selectedColor = Colors.grey.withOpacity(0.8);
    }
    _notSelectedTextStyle = TextStyle(color: _selectedColor);
    _notSelectedColor = _selectedColor.withOpacity(0.2);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 128,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        border: Border.all(width: 0.5, color: _selectedColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //width: _width + 8,
              //padding: EdgeInsets.only(left: 4, right: 2,),
              decoration: BoxDecoration(
                color: schedule != null
                    ? (schedule.monday
                        ? _selectedColor
                        : _notSelectedColor)
                    : _notSelectedColor,
                /* borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),*/
                /*border: Border(
                right: BorderSide(width: 0.5),
              ),*/
              ),
              child: Text(
                "M",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.monday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          ),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //width: _width,
              //padding: EdgeInsets.only(left: 2, right: 2),
              color: schedule != null
                  ? (schedule.tuesday
                      ? _selectedColor
                      : _notSelectedColor)
                  : _notSelectedColor,
              child: Text(
                "T",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.tuesday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          ),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //width: _width,
              //padding: EdgeInsets.only(left: 2, right: 2, ),
              color: schedule != null
                  ? (schedule.wednesday
                      ? _selectedColor
                      : _notSelectedColor)
                  : _notSelectedColor,
              child: Text(
                "W",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.wednesday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          ),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              // width: _width,
              //padding: EdgeInsets.only(left: 2, right: 2, ),
              color: schedule != null
                  ? (schedule.thursday
                      ? _selectedColor
                      : _notSelectedColor)
                  : _notSelectedColor,
              child: Text(
                "T",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.thursday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          ),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //width: _width,
              //padding: EdgeInsets.only(left: 2, right: 2, ),
              color: schedule != null
                  ? (schedule.friday
                      ? _selectedColor
                      : _notSelectedColor)
                  : _notSelectedColor,
              child: Text(
                "F",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.friday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          ),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //width: _width,
              //padding: EdgeInsets.only(left: 2, right: 2,),
              color: schedule != null
                  ? (schedule.saturday
                      ? _selectedColor
                      : _notSelectedColor)
                  : _notSelectedColor,
              child: Text(
                "S",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.saturday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          ),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //width: _width + 4,
              //padding: EdgeInsets.only(left: 2, right: 8, ),
              decoration: BoxDecoration(
                color: schedule != null
                    ? (schedule.sunday
                        ? _selectedColor
                        : _notSelectedColor)
                    : _notSelectedColor,
                /*borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))*/
              ),
              child: Text(
                "S",
                textAlign: TextAlign.center,
                style: schedule != null
                    ? (schedule.sunday
                        ? _selectedTextStyle
                        : _notSelectedTextStyle)
                    : _notSelectedTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
