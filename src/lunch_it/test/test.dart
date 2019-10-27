import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:lunch_it/FoodPicker/Ocr/Ocr.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

/*  test('server connection test', () async  {
    WidgetsFlutterBinding.ensureInitialized();
    ServerProxy proxy = ServerProxy();

    //Future<String> text = proxy.getAsText(r"C:\Users\jakub\Desktop\data\Screenshot_16.png");
    var result = proxy.ping();

    Response resp;
    var callback = expectAsync1((Response response)
    {
      checkResp(response);


      }, count: 1);
    result.then(callback);

  });*/




  test('ocr test', () async {

    WidgetsFlutterBinding.ensureInitialized();
    ServerProxy proxy = ServerProxy();

    String filePath = "C:/Users/jakub/Desktop/data/Screenshot_16.png";

    var result = proxy.upload(filePath);

    var callback = expectAsync1((result)
    {
      checkResult(result);


    }, count: 1);
    result.then(callback);

  });

}

void checkResp(Response response){
  print(response);
}

void checkResult(result)
{
  print(result);
}
