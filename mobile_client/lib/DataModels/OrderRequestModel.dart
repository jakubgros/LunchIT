import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lunch_it/Utilities/Utils.dart';

class OrderRequestModel {
  final double priceLimit;
  final String title;
  final DateTime deadline;
  final String message;
  final int placedOrderId;
  final int orderRequestId;
  final String menuUrl;

  OrderRequestModel({
    @required this.orderRequestId,
    @required this.priceLimit,
    @required this.title,
    @required this.deadline,
    @required this.menuUrl,
    this.placedOrderId,
    this.message,
  });

  OrderRequestModel.fromJsonString(String json): this.fromJsonMap(jsonDecode(json));

  OrderRequestModel.fromJsonMap(Map<String, dynamic> parsedJson) :
    orderRequestId = getOrThrow(parsedJson, "id"),
    placedOrderId =  getOrThrow(parsedJson, "placed_order_id"),
    title = getOrThrow(parsedJson, "name"),
    priceLimit = getOrThrow(parsedJson, "price_limit"),
    deadline = DateTime.parse(getOrThrow(parsedJson, "deadline")),
    message = getOrThrow(parsedJson, "message"),
    menuUrl = getOrThrow(parsedJson, "menu_url");


  String _getWithFollowingZeroIfNeeded(int val) {
    if(val<10)
      return "0$val";
    else
      return "$val";
  }

  String _getDateAsFormattedString(DateTime d){
    String year = d.year.toString();
    String month = _getWithFollowingZeroIfNeeded(d.month);
    String day = _getWithFollowingZeroIfNeeded(d.day);
    String hour = _getWithFollowingZeroIfNeeded(d.hour);
    String minute = _getWithFollowingZeroIfNeeded(d.minute);
    return "$year-$month-$day $hour:$minute";
  }

  String _getTimeLeftAsFormattedString(Duration d){
    if(d.inDays > 0)
      return "${d.inDays} days";
    if(d.inHours > 0)
      return "${d.inHours} hours";
    if (d.inMinutes > 0)
      return "${d.inMinutes} minutes";
    else
      return "${d.inSeconds} seconds";
  }

  String get deadlineAsFormattedStr => _getDateAsFormattedString(deadline);
  String get timeLeftAsFormattedString => _getTimeLeftAsFormattedString(timeLeft);
  bool hasExpired() => DateTime.now().isAfter(deadline);
  bool canOrder() => !hasExpired() && placedOrderId==null;
  bool get isOrdered => placedOrderId!=null;
  Duration get timeLeft => deadline.difference(DateTime.now());
}