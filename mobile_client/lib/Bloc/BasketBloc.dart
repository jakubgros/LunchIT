import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/DataModels/OrderResponseModel.dart';
import 'package:rxdart/rxdart.dart';

class BasketBloc {

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

  Future<bool> placeOrder(int orderRequestId) async {
    var order = OrderResponseModel(_meals, orderRequestId);
    Future<bool> success = ServerApi().placeOrder(order);
    if(await success) {
      clear();
    }
    return success;
  }
}