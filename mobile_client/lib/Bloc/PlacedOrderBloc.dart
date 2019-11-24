import 'dart:async';

import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/DataModels/PlacedOrderModel.dart';

class PlacedOrderBloc {
  var _mealsStreamController = StreamController<PlacedOrderModel>.broadcast();

  Stream<PlacedOrderModel> get placedOrder => _mealsStreamController.stream;

  void init(OrderRequestModel orderRequest) async {
    List<MealModel> meals = await ServerApi().getPlacedOrder(orderRequest.placedOrderId);
    _mealsStreamController.sink.add(PlacedOrderModel(orderRequest, meals));
  }

  void dispose() {
    _mealsStreamController.close();
  }
}
