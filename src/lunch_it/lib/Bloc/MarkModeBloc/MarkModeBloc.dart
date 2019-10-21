import 'dart:async';

import 'package:lunch_it/Bloc/BlocBase.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkEvent.dart';
import 'package:lunch_it/Bloc/MarkModeBloc/MarkModeState.dart';

class MarkModeBloc extends BlocBase{
  final _stateController = StreamController<MarkModeState>.broadcast();
  Stream<MarkModeState> get state => _stateController.stream;

  final _eventController = StreamController<MarkEvent>();
  Sink<MarkEvent> get event => _eventController.sink;

  MarkModeBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(MarkEvent event) {
    if(event is MarkFoodEvent)
      _stateController.sink.add(MarkModeState.foodMode());
    else if(event is MarkPriceEvent)
      _stateController.sink.add(MarkModeState.priceMode());
    else if(event is NavigateEvent)
      _stateController.sink.add(MarkModeState.navigateMode());
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
