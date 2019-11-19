
import 'BasketModel.dart';

class OrderResponse {
  final Basket basket;
  final int orderRequestId;

  OrderResponse(this.basket, this.orderRequestId);

  Map toJson() => {
        "orderRequestId": orderRequestId,
        "basketData": basket,
      };
}
