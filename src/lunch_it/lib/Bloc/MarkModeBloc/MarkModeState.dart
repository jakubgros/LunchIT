class MarkModeState {
  int _mode=-1;
  MarkModeState._();

  bool isNavigateMode() => _mode == 0;
  bool isFoodMode() => _mode == 1;
  bool isPriceMode() => _mode == 2;

  factory MarkModeState.navigateMode() => MarkModeState._().._mode = 0;
  factory MarkModeState.foodMode() => MarkModeState._().._mode = 1;
  factory MarkModeState.priceMode() => MarkModeState._().._mode = 2;
}