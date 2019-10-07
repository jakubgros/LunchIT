import 'dart:async';

abstract class MarkEvent {}
class MarkFoodEvent extends MarkEvent {}
class MarkPriceEvent extends MarkEvent {}
class NavigateEvent extends MarkEvent {}

class MarkModeState {
  int _mode;
  MarkModeState._();

  bool isNavigateMode() => _mode == 0;
  bool isFoodMode() => _mode == 1;
  bool isPriceMode() => _mode == 2;

  factory MarkModeState.navigateMode() => MarkModeState._().._mode = 0;
  factory MarkModeState.foodMode() => MarkModeState._().._mode = 1;
  factory MarkModeState.priceMode() => MarkModeState._().._mode = 2;
}

class MarkModeBloc {
  final _stateController = StreamController<MarkModeState>();
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
