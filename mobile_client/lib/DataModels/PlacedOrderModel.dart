import 'MealModel.dart';
import 'OrderRequestModel.dart';

class PlacedOrderModel {
  OrderRequestModel connectedOrderRequest;
  List<MealModel> orderedMeals;

  PlacedOrderModel(this.connectedOrderRequest, this.orderedMeals);

  double get totalCost => orderedMeals.fold(0, (prev, MealModel elem) => prev + elem.price*elem.quantity);
}