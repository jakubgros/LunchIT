class Validator {
  static bool isPrice(String str) {
    Pattern price = r'^\s*[0-9]+((.|,)[0-9]{1,2})?\s*(PLN|ZL|ZŁ|ZŁOTYCH)?\s*$';
    var regExp = RegExp(price, caseSensitive: false);
    bool onlyOneMatch = regExp.allMatches(str).length == 1;

    return onlyOneMatch;
  }
}