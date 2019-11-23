import 'dart:async';

import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';

class OrderRequestBloc {

  StreamController _streamController = StreamController<List<OrderRequestModel>>.broadcast();

  List<OrderRequestModel> _orderRequests = [];

  OrderRequestBloc() {
    update();
  }

  void update() async {
    await ServerApi().loggedInFuture;
    _orderRequests = await ServerApi().getOrderRequestsForCurrentUser();
    _streamController.sink.add(_orderRequests);
  }

  Stream<List<OrderRequestModel>> get orderRequests => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}