import 'package:flutter/foundation.dart';

class OrderRequest {
  double _priceLimit;
  String _title;
  DateTime _deadline;
  String _message;
  int _placedOrderId;
  int _orderRequestId;
  String _menuUrl;

  double get priceLimit => _priceLimit;
  String get title => _title;
  DateTime get deadline => _deadline;
  String get message => _message;
  int get placedOrderId => _placedOrderId;
  int get orderRequestId => _orderRequestId;
  String get menuUrl => _menuUrl;

  OrderRequest({
    @required orderRequestId,
    @required priceLimit,
    @required title,
    @required deadline,
    @required menuUrl,
    placedOrderId,
    message,
  }):
    _orderRequestId = orderRequestId,
    _priceLimit = priceLimit,
    _title = title,
    _deadline = deadline,
    _menuUrl = menuUrl,
    _placedOrderId = placedOrderId,
    _message = message;

  void assign(OrderRequest other) {
    _priceLimit = other._priceLimit;
    _title = other._title;
    _deadline = other._deadline;
    _message = other._message;
    _placedOrderId = other._placedOrderId;
    _orderRequestId = other._orderRequestId;
    _menuUrl = other._menuUrl;
  }

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
