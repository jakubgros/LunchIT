import 'package:flutter_test/flutter_test.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

void main() {
  test('simple test', () {
    
    Future<String> text = ServerApi().getAsText(r"C:\Users\jakub\Desktop\data\Screenshot_12.png");
    text.then(
        expectAsync1((value) {print(value);}),
    );

  });
}