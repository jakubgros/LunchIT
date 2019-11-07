import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lunch_it/Basket/BasketData.dart';
import 'package:lunch_it/Basket/Order.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:password/password.dart';

class ServerApi
{
  static String _serverAdress = "10.0.2.2:5002";
  final http.Client _client = http.Client();

  String _email = "";
  String _hashedPassword = "";

  void closeConnection() { //TODO call it somewhere
    _client.close();
  }

  Map<String, String> _getAuthHeader() {
    var authHeader = Map<String, String>.from({'authorization': "$_email:$_hashedPassword"});
    return authHeader;
  }

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


  Future<bool> placeOrder(Order order) async { //TODO make it work on seperate isolate
    const String endpoint = "/order";
    // ==============================


    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    var uri = Uri.http(_serverAdress, endpoint); //TODO make all of queries look like this method
    http.Request request = http.Request("POST", uri);
    request.headers.addAll(_getAuthHeader());
    request.headers.addAll(headers);
    request.body = jsonEncode(order);

    http.StreamedResponse streamedResponse = await _client.send(request);
    http.Response response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200;
  }


  Future<bool> checkUser(String email, String password) async {
    const String endpoint = "/authenticate";
    // ==============================
    String hashedPassword = _hash(password);
    String body = jsonEncode(
      {
        "user_id": email,
        "hashed_password": hashedPassword,
      });

    var uri = Uri.http(_serverAdress, endpoint);

    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(uri, body: body, headers: headers);
    final responseJson = json.decode(response.body);

    bool isUserValid = responseJson['authenticated'] == true;

    if(isUserValid) { // save for future calls
      _email = email;
      _hashedPassword = hashedPassword;
    }
    return isUserValid;
  }

  String _hash(String password) {
    final algorithm = PBKDF2();
    String hash = Password.hash(password, algorithm);
    return hash;
}


  ServerApi._privateCtor();
  static final ServerApi _singleton = ServerApi._privateCtor();
  factory ServerApi() => _singleton;


}