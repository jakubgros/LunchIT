import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/DataModels/OrderResponseModel.dart';
import 'package:rxdart/rxdart.dart';

class OrderResponseBloc {

  OrderResponseBloc() {
    _update();
  }

  final _basketSubject = BehaviorSubject<List<MealModel>>();

  Stream<List<MealModel>> get basket => _basketSubject.stream;

  final _meals = List<MealModel>();

  void _update() {
    _basketSubject.sink.add(_meals);
  }

  void addEntry(MealModel newEntry) {
    _meals.add(newEntry);
    _update();
  }

  void removeEntry(int index) {
    _meals.removeAt(index);
    _update();
  }

  void clear() {
    _meals.clear();
    _update();
  }

  double getSummaryCost() => _meals.fold(0, (previousVal, elem) => previousVal+elem.quantity*elem.price);

  int get length => _meals.length;

  Map toJson() => {
    "meals": _meals,
  };

  void dispose() {
    _basketSubject.close();
  }

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
  }

  double get priceLimit => _currentOrderRequest.priceLimit;

  Stream<OrderResponseInfo> get orderInfo => basket.map((_) => OrderResponseInfo(
    priceLimit: _currentOrderRequest.priceLimit,
    moneyLeft: _currentOrderRequest.priceLimit - getSummaryCost(),
    summaryCost: getSummaryCost(),
  ));

  void setNewQuantity(MealModel meal, int newQuantity) {
    meal.quantity = newQuantity;
    _update();
  }
}

class OrderResponseInfo {
  final double priceLimit;
  final double moneyLeft;
  final double summaryCost;

  OrderResponseInfo({this.priceLimit, this.moneyLeft, this.summaryCost});

}
