import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lunch_it/FoodPicker/Basket/BasketData.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerApi
{
  static String _serverAdress = "10.0.2.2:5002";

  Future<String> getAsText(File imageFile) => compute(_getAsText, imageFile);
  static Future<String> _getAsText(File imageFile) async {
    String endpoint = "/getAsText";
    String method = "POST";
    // ==============================


    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.http(_serverAdress, endpoint);
    var request = http.MultipartRequest(method, uri);

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();
    //TODO implement status code checking from response.statusCode

    String result = await response.stream.transform(utf8.decoder).elementAt(0);

    return result;
  }


  Future<String> placeOrder(BasketData basketData) async { //TODO make it work on seperate isolate
    const String endpoint = "/order";
    // ==============================

    String body = jsonEncode(basketData);

    var uri = Uri.http(_serverAdress, endpoint);

    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(uri, body: body, headers: headers);
    final responseJson = json.decode(response.body);

    return responseJson['statusCode'];
  }






    ServerApi._privateCtor();
    static final ServerApi _singleton = ServerApi._privateCtor();
    factory ServerApi() => _singleton;
}