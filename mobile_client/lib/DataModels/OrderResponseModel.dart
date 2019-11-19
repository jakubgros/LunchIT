import 'BasketModel.dart';

class OrderResponseModel {
  final BasketModel basket;
  final int orderRequestId;

  OrderResponseModel(this.basket, this.orderRequestId);

  Map toJson() => {
        "orderRequestId": orderRequestId,
        "basketData": basket,
      };
}
