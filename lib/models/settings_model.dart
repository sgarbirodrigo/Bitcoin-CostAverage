import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../external/binance_api.dart';

class SettingsApp {
  Map<String, double> binanceTicker;
  String base_pair;
  ScaleLineChart scaleLineChart;
  final Function(SettingsApp newSettingsApp) _updateWidgets;
  SharedPreferences preferences;
  String _base_pair_preference = "base_pair";
  String _scale_line_preference = "scale_line";

  SettingsApp(this._updateWidgets) {
    scaleLineChart = ScaleLineChart.WEEK1;
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      this.base_pair = preferences.getString(_base_pair_preference);
      this.scaleLineChart = _getScale();
      this._updateWidgets(this);
    });
  }


  void forceUpdate() {
    this._updateWidgets(this);
  }

  void updateBinancePrice() async {
    this.binanceTicker = await fetchBinancePairData();
    this._updateWidgets(this);
  }

  void updateScaleLineChart(ScaleLineChart scaleLineChart) {
    this.scaleLineChart = scaleLineChart;
    this._saveScale(scaleLineChart);
    this._updateWidgets(this);
  }

  String getBaseCoin() {
    return base_pair.split("/")[1];
  }

  ScaleLineChart _getScale() {
    ScaleLineChart scale = ScaleLineChart.WEEK1;
    switch (this.preferences.getString(_scale_line_preference)) {
      case "WEEK1":
        scale = ScaleLineChart.WEEK1;
        break;
      case "WEEK2":
        scale = ScaleLineChart.WEEK2;
        break;
      case "MONTH1":
        scale = ScaleLineChart.MONTH1;
        break;
      case "MONTH6":
        scale = ScaleLineChart.MONTH6;
        break;
      case "YEAR1":
        scale = ScaleLineChart.YEAR1;
        break;
    }
    return scale;
  }

  _saveScale(ScaleLineChart scale) {
    switch (scale) {
      case ScaleLineChart.WEEK1:
        this.preferences.setString(_scale_line_preference, "WEEK1");
        break;
      case ScaleLineChart.WEEK2:
        this.preferences.setString(_scale_line_preference, "WEEK2");
        break;
      case ScaleLineChart.MONTH1:
        this.preferences.setString(_scale_line_preference, "MONTH1");
        break;
      case ScaleLineChart.MONTH6:
        this.preferences.setString(_scale_line_preference, "MONTH6");
        break;
      case ScaleLineChart.YEAR1:
        this.preferences.setString(_scale_line_preference, "YEAR1");
        break;
    }
  }

  void updateBasePair(String pair) {
    this.base_pair = pair;
    this.preferences.setString(_base_pair_preference, pair);
    this._updateWidgets(this);
  }
}
