import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeekIndicator extends StatefulWidget {
  Schedule schedule;
  WeekIndicator(this.schedule);
  @override
  State<StatefulWidget> createState() {
    return _WeekIndicatorState();
  }
}

class Schedule {
  //bool monday=false;
  bool monday = false,
      tuesday = true,
      wednesday = true,
      thursday = false,
      friday = true,
      saturday = false,
      sunday = true;

  Schedule({this.monday, this.tuesday, this.wednesday, this.thursday,
      this.friday, this.saturday, this.sunday});
}

class _WeekIndicatorState extends State<WeekIndicator> {
  @override
  Widget build(BuildContext context) {
    Color _selectedColor = Colors.grey;
    Color _notSelectedColor = _selectedColor.withOpacity(0.2);
    TextStyle _selectedTextStyle = TextStyle(color: Colors.white);
    TextStyle _notSelectedTextStyle = TextStyle();
    double _width = 14;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(width: 0.5, color: _selectedColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: _width + 8,
            //padding: EdgeInsets.only(left: 4, right: 2,),
            decoration: BoxDecoration(
              color:
                  widget.schedule!=null ? (widget.schedule.monday ? _selectedColor : _notSelectedColor):_notSelectedColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              /*border: Border(
                right: BorderSide(width: 0.5),
              ),*/
            ),
            child: Text(
              "M",
              textAlign: TextAlign.center,
              style:  widget.schedule!=null ? (widget.schedule.monday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          ),
          Container(height: 16,width: 1,color: _selectedColor,),
          Container(
            width: _width,
            //padding: EdgeInsets.only(left: 2, right: 2),
            color: widget.schedule!=null ? (widget.schedule.tuesday ? _selectedColor : _notSelectedColor):_notSelectedColor,
            child: Text(
              "T",
              textAlign: TextAlign.center,
              style: widget.schedule!=null ? (widget.schedule.tuesday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          ),
          Container(height: 16,width: 1,color: _selectedColor,),
          Container(
            width: _width,
            //padding: EdgeInsets.only(left: 2, right: 2, ),
            color:
    widget.schedule!=null ? (widget.schedule.wednesday ? _selectedColor : _notSelectedColor):_notSelectedColor,
            child: Text(
              "W",
              textAlign: TextAlign.center,
              style: widget.schedule!=null ? (widget.schedule.wednesday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          ),
          Container(height: 16,width: 1,color: _selectedColor,),
          Container(
            width: _width,
            //padding: EdgeInsets.only(left: 2, right: 2, ),
            color:
    widget.schedule!=null ? (widget.schedule.thursday ? _selectedColor : _notSelectedColor):_notSelectedColor,
            child: Text(
              "T",
              textAlign: TextAlign.center,
              style: widget.schedule!=null ? (widget.schedule.thursday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          ),
          Container(height: 16,width: 1,color: _selectedColor,),
          Container(
            width: _width,
            //padding: EdgeInsets.only(left: 2, right: 2, ),
            color: widget.schedule!=null ? (widget.schedule.friday ? _selectedColor : _notSelectedColor):_notSelectedColor,
            child: Text(
              "F",
              textAlign: TextAlign.center,
              style: widget.schedule!=null ? (widget.schedule.friday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          ),
          Container(height: 16,width: 1,color: _selectedColor,),
          Container(
            width: _width,
            //padding: EdgeInsets.only(left: 2, right: 2,),
            color:
    widget.schedule!=null ? (widget.schedule.saturday ? _selectedColor : _notSelectedColor):_notSelectedColor,
            child: Text(
              "S",
              textAlign: TextAlign.center,
              style: widget.schedule!=null ? (widget.schedule.saturday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          ),
          Container(height: 16,width: 1,color: _selectedColor,),
          Container(
            width: _width + 4,
            //padding: EdgeInsets.only(left: 2, right: 8, ),
            decoration: BoxDecoration(
                color:
    widget.schedule!=null ? (widget.schedule.sunday ? _selectedColor : _notSelectedColor):_notSelectedColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            child: Text(
              "S",
              textAlign: TextAlign.center,
              style: widget.schedule!=null ? (widget.schedule.sunday
                  ? _selectedTextStyle
                  : _notSelectedTextStyle):_notSelectedTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
