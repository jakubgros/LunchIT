

class NavbarBlocState {
  int _mode=-1;
  NavbarBlocState._();

  bool isGoBack() => _mode == 0;
  bool isGoForward() => _mode == 1;

  factory NavbarBlocState.goBack() => NavbarBlocState._().._mode = 0;
  factory NavbarBlocState.goForward() => NavbarBlocState._().._mode = 1;
}