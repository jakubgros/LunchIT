import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:lunch_it/DataModels/OrderResponseInfoModel.dart';
import 'package:lunch_it/DataModels/OrderResponseModel.dart';
import 'package:rxdart/rxdart.dart';

class OrderResponseBloc {
  final _orderResponseInfoSubject = BehaviorSubject<OrderResponseInfoModel>();
  final _basketSubject = BehaviorSubject<List<MealModel>>();
  final _currentOrderRequestSubject = BehaviorSubject<OrderRequestModel>();
  final _meals = List<MealModel>();
  OrderRequestModel _currentOrderRequest;

  Stream<List<MealModel>> get basket => _basketSubject.stream;
  Stream<OrderRequestModel> get currentOrderRequest => _currentOrderRequestSubject.stream;
  Stream<OrderResponseInfoModel> get orderInfo => _orderResponseInfoSubject.stream;

  OrderResponseBloc() {
    _basketSubject.listen((_) {
      if(_currentOrderRequest != null)
        _updateResponseInfo();
    });

    _updateMeals();
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

  Map toJson() => {
    "meals": _meals,
  };

  void setCurrentOrderRequest(OrderRequestModel newOrderRequest) {
    _currentOrderRequest = newOrderRequest;
    _currentOrderRequestSubject.sink.add(newOrderRequest);
    _updateResponseInfo();
  }

  void setNewQuantity(MealModel meal, int newQuantity) {
    meal.quantity = newQuantity;
    _updateMeals();
  }

  Future<bool> placeOrder() async {
    var order = OrderResponseModel(_meals, _currentOrderRequest.orderRequestId);
    Future<bool> success = ServerApi().placeOrder(order);
    if(await success) {
      clear();
    }
    return success;
  }

  void dispose() {
    _basketSubject.close();
    _orderResponseInfoSubject.close();
    _currentOrderRequestSubject.close();
  }

  void _updateResponseInfo() {
    _orderResponseInfoSubject.sink.add(_calculateResponseInfo());
  }

  void _updateMeals() {
    _basketSubject.sink.add(_meals);
  }

  OrderResponseInfoModel _calculateResponseInfo(){
    return OrderResponseInfoModel(
      moneyLeft: _currentOrderRequest.priceLimit - getSummaryCost(),
      summaryCost: getSummaryCost(),
    );
  }
}
