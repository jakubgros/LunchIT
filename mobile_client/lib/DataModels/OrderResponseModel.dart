import 'MealModel.dart';

class OrderResponseModel {
  final List<MealModel> basket;
  final int orderRequestId;

  OrderResponseModel(this.basket, this.orderRequestId);

  Map toJson() => {
        "orderRequestId": orderRequestId,
        "basketData": basket,
      };
}
