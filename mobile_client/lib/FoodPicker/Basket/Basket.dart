class BasketEntry {
  String _foodName;
  double _price;
  int _quantity;
  String _comment;

  String get foodName => _foodName;
  double get price => _price;
  int get quantity => _quantity;
  String get comment => _comment;

  BasketEntry(this._foodName, this._price, this._quantity, this._comment);
}