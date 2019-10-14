import 'dart:async';
import 'package:lunch_it/Bloc/BlocBase.dart';

import 'NavbarBlocEvent.dart';
import 'NavbarBlocState.dart';

class NavbarBloc extends BlocBase{
  final _stateController = StreamController<NavbarBlocState>();
  Stream<NavbarBlocState> get state => _stateController.stream;

  final _eventController = StreamController<NavbarBlocEvent>();
  Sink<NavbarBlocEvent> get event => _eventController.sink;

  NavbarBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(NavbarBlocEvent event) {
    if(event is NavbarGoBackEvent)
      _stateController.sink.add(NavbarBlocState.goBack());
    else if(event is NavbarGoForwardEvent)
      _stateController.sink.add(NavbarBlocState.goForward());
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
