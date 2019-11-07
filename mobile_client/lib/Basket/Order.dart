import 'package:lunch_it/Basket/BasketData.dart';

class Order {
  final BasketData basketData;
  final int orderRequestId;

  Order(this.basketData, this.orderRequestId);

  Map toJson() =>
      {
        "orderRequestId": orderRequestId,
        "basketData": basketData,
      };
}
