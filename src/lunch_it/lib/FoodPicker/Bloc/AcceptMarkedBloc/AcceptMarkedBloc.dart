import 'dart:async';

import 'package:lunch_it/FoodPicker/Bloc/AcceptMarkedBloc/AcceptMarkedBlocEvent.dart';
import 'package:lunch_it/FoodPicker/Bloc/AcceptMarkedBloc/AcceptMarkedBlocState.dart';
import 'package:lunch_it/FoodPicker/Bloc/BlocBase.dart';

class AcceptMarkedBloc extends BlocBase{ //TODO extract blocs to template or something
  final _stateController = StreamController<AcceptMarkedBlocState>();
  Stream<AcceptMarkedBlocState> get state => _stateController.stream;

  final _eventController = StreamController<AcceptMarkedBlocEvent>();
  Sink<AcceptMarkedBlocEvent> get event => _eventController.sink;

  AcceptMarkedBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(AcceptMarkedBlocEvent event) {
    if(event is AcceptMarkedFoodEvent)
      _stateController.sink.add(AcceptMarkedBlocState.markedFood());
    else if(event is AcceptMarkedPriceEvent)
      _stateController.sink.add(AcceptMarkedBlocState.markedPrice());
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
