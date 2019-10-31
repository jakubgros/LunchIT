import 'package:flutter_test/flutter_test.dart';
import 'package:lunch_it/Utilities/Validator.dart';


void main() {

  test('coma and dot as separator', () {
    expect(Validator.isPrice("13.50"), true);
    expect(Validator.isPrice("13,50"), true);
  });

  test('only one or two digits after separator', () {
    expect(Validator.isPrice("13.5"), true);
    expect(Validator.isPrice("13.50"), true);
    expect(Validator.isPrice("13."), false);
    expect(Validator.isPrice("13.500"), false);
  });

  test('at least one digit before separator', () {
    expect(Validator.isPrice("00.50"), true);
    expect(Validator.isPrice("0.50"), true);
    expect(Validator.isPrice(".50"), false);
  });

  test('only Polish currency is allowed', () {
    expect(Validator.isPrice("13.50 zł"), true);
    expect(Validator.isPrice("13.50 zl"), true);
    expect(Validator.isPrice("13.50 złotych"), true);
    expect(Validator.isPrice("13.50 pln"), true);
    expect(Validator.isPrice("1 pln"), true);
  });

  test('currency is case insensitive', () {
    expect(Validator.isPrice("13.50 PLN"), true);
    expect(Validator.isPrice("13.50 pln"), true);
  });

  test('spare spaces are acceptable before, after price and before, after currency', () {
    expect(Validator.isPrice(" 13.50"), true);
    expect(Validator.isPrice(" 13.50 "), true);
    expect(Validator.isPrice(" 13.50 "), true);
    expect(Validator.isPrice(" 13.50 "), true);
    expect(Validator.isPrice(" 13.50  pln "), true);
    expect(Validator.isPrice("13,50"), true);
  });
}
