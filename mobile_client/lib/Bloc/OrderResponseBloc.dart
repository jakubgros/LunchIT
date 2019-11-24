import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/DataModels/OrderResponseModel.dart';
import 'package:rxdart/rxdart.dart';

class OrderResponseBloc {

  OrderResponseBloc() {
    _basketSubject.listen((_) {
      if(_currentOrderRequest != null)
        updateResponseInfo();
    });

    _updateMeals();
  }

  final _basketSubject = BehaviorSubject<List<MealModel>>();

  Stream<List<MealModel>> get basket => _basketSubject.stream;

  final _meals = List<MealModel>();

  void _updateMeals() {
    _basketSubject.sink.add(_meals);
  }

  void addEntry(MealModel newEntry) {
    _meals.add(newEntry);
    _updateMeals();
  }

  void removeEntry(int index) {
    _meals.removeAt(index);
    _updateMeals();
  }

  void clear() {
    _meals.clear();
    _updateMeals();
  }

  double getSummaryCost() => _meals.fold(0, (previousVal, elem) => previousVal+elem.quantity*elem.price);

  int get length => _meals.length;

  Map toJson() => {
    "meals": _meals,
  };


  Future<bool> placeOrder() async {
    var order = OrderResponseModel(_meals, _currentOrderRequest.orderRequestId);
    Future<bool> success = ServerApi().placeOrder(order);
    if(await success) {
      clear();
    }
    return success;
  }

  // ==================================================================


  final _currentOrderRequestSubject = BehaviorSubject<OrderRequestModel>();

  Stream<OrderRequestModel> get currentOrderRequest => _currentOrderRequestSubject.stream;

  OrderRequestModel _currentOrderRequest;

  void setCurrentOrderRequest(OrderRequestModel newOrderRequest) {
    _currentOrderRequest = newOrderRequest;
    _currentOrderRequestSubject.sink.add(newOrderRequest);
    updateResponseInfo();
  }

  void updateResponseInfo() {
    _orderResponseInfoSubject.sink.add(_calculateResponseInfo());
  }

  double get priceLimit => _currentOrderRequest.priceLimit;

  final _orderResponseInfoSubject = BehaviorSubject<OrderResponseInfo>();

  Stream<OrderResponseInfo> get orderInfo => _orderResponseInfoSubject.stream;

  void setNewQuantity(MealModel meal, int newQuantity) {
    meal.quantity = newQuantity;
    _updateMeals();
  }

  OrderResponseInfo _calculateResponseInfo() =>
      OrderResponseInfo(
    moneyLeft: _currentOrderRequest.priceLimit - getSummaryCost(),
    summaryCost: getSummaryCost(),
  );

  void dispose() {
    _basketSubject.close();
    _orderResponseInfoSubject.close();
    _currentOrderRequestSubject.close();
  }


}

class OrderResponseInfo {
  final double moneyLeft;
  final double summaryCost;

  OrderResponseInfo({this.moneyLeft, this.summaryCost});

}
