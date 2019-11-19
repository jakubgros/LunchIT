import 'dart:async';

class WebNavigationEventStream {
  StreamController _controller = StreamController<WebNavigationEvent>();
  get stream => _controller.stream;
  get sink => _controller.sink;

  void close() => _controller.close();
}

class WebNavigationEvent {
  _EventType _type;
  WebNavigationEvent._();

  bool isGoBack() => _type == _EventType.goBack;
  bool isGoForward() => _type == _EventType.goForward;

  factory WebNavigationEvent.goBack() => WebNavigationEvent._().._type = _EventType.goBack;
  factory WebNavigationEvent.goForward() => WebNavigationEvent._().._type = _EventType.goForward;
}

enum _EventType {
  goBack,
  goForward
}