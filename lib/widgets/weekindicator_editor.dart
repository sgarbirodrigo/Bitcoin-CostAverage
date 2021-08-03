import 'package:bitcoin_cost_average/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeekIndicatorEditor extends StatefulWidget {
  Schedule schedule;
  Function(Schedule schedule) onChange;

  WeekIndicatorEditor(this.schedule, this.onChange);

  @override
  State<StatefulWidget> createState() {
    return _WeekIndicatorEditorState();
  }
}


class _WeekIndicatorEditorState extends State<WeekIndicatorEditor> {
  Color _selectedColor;
  Color _notSelectedColor;
  TextStyle _selectedTextStyle;
  TextStyle _notSelectedTextStyle;

  Widget getDay(
      String dayName, bool weekDayState, Function(bool value) onChange) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.schedule != null
                ? (weekDayState ? _selectedColor : _notSelectedColor)
                : _notSelectedColor,
          ),
          child: Text(
            dayName,
            textAlign: TextAlign.center,
            style: widget.schedule != null
                ? (weekDayState ? _selectedTextStyle : _notSelectedTextStyle)
                : _notSelectedTextStyle,
          ),
        ),
        onTap: () {
          onChange(!weekDayState);
        },
      ),
    );
  }

  @override
  void initState() {
    _selectedColor = Colors.deepPurple.withOpacity(0.8);
    _notSelectedColor = _selectedColor.withOpacity(0.2);
    _selectedTextStyle = TextStyle(color: Colors.white);
    _notSelectedTextStyle = TextStyle(color: _selectedColor);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {
      fn();
      widget.onChange(widget.schedule);
    });
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 4;
    return Container(
      height: 18,
      width: 256,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(width: 0.5, color: _selectedColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getDay("M", widget.schedule.monday,
              (value) => setState(() => widget.schedule.monday = value)),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          getDay("T", widget.schedule.tuesday,
              (value) => setState(() => widget.schedule.tuesday = value)),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          getDay("W", widget.schedule.wednesday,
              (value) => setState(() => widget.schedule.wednesday = value)),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          getDay("T", widget.schedule.thursday,
              (value) => setState(() => widget.schedule.thursday = value)),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          getDay("F", widget.schedule.friday,
              (value) => setState(() => widget.schedule.friday = value)),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          getDay("S", widget.schedule.saturday,
              (value) => setState(() => widget.schedule.saturday = value)),
          Container(
            width: 1,
            color: _selectedColor,
          ),
          getDay("S", widget.schedule.sunday,
              (value) => setState(() => widget.schedule.sunday = value)),
        ],
      ),
    );
  }
}
