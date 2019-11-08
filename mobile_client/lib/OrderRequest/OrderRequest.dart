import 'package:flutter/foundation.dart';

class OrderRequest {
  final double priceLimit;
  final String title;
  final DateTime deadline;
  final String message;
  final int orderId;

  OrderRequest({
    @required this.priceLimit,
    @required this.title,
    @required this.deadline,
    this.orderId,
    this.message,
  });

  bool hasExpired() => DateTime.now().isAfter(deadline);
  bool canOrder() => !hasExpired() && orderId==null;
  bool get isOrdered => orderId!=null;
}
