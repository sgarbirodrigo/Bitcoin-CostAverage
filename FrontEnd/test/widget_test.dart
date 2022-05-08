// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  test('test porcentages', () {
    expect(getValueVariation(100, 100), 0);
    expect(getValueVariation(100, 80), 20);
    expect(getValueVariation(100, 120), -20);
  });


  test('db test', ()async{
    // Get a location using getDatabasesPath
     var userHistory = await UserManager.getHistoryData();
     expect(userHistory,1);
  });
  test('Future.value() returns the value', () async {
    var value = await Future.value(10);
    expect(value, equals(10));
  });
}
