
import 'BasketModel.dart';

class OrderResponse {
  final Basket basket;
  final int orderRequestId;

  OrderResponse(this.basket, this.orderRequestId);

  Map toJson() => {
        "orderRequestId": orderRequestId, //TODO change name
        "basketData": basket, //TODO change name
      };
}
