

class NavbarBlocState {
  int _mode=-1;
  NavbarBlocState._();

  bool isGoForward() => _mode == 0;
  bool isGoBack() => _mode == 1;

  factory NavbarBlocState.goForward() => NavbarBlocState._().._mode = 0;
  factory NavbarBlocState.goBack() => NavbarBlocState._().._mode = 1;
}