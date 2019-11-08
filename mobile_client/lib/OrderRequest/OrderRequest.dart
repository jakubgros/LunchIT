import 'package:flutter/foundation.dart';

class OrderRequest {
  final double priceLimit;
  final String title;
  final DateTime deadline;
  final String message;
  final int placedOrderId;
  final int orderRequestId;

  OrderRequest({
    @required this.orderRequestId,
    @required this.priceLimit,
    @required this.title,
    @required this.deadline,
    this.placedOrderId,
    this.message,
  });

  bool hasExpired() => DateTime.now().isAfter(deadline);
  bool canOrder() => !hasExpired() && placedOrderId==null;
  bool get isOrdered => placedOrderId!=null;
}
