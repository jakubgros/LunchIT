import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lunch_it/Basket/BasketData.dart';
import 'package:lunch_it/Basket/BasketEntry.dart';
import 'package:lunch_it/Basket/Order.dart';
import 'package:lunch_it/OrderRequest/OrderRequest.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:password/password.dart';
import 'package:path_provider/path_provider.dart';

class ServerApi
{
  static String _serverAdress = "10.0.2.2:5002";
  final http.Client _client = http.Client();

  String _email;
  String _hashedPassword;

  Future<String> get _rememberedCredentialsFilePath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String credFileName = "cred.txt";
    return appDocDir.path + "/" + credFileName;
  }
  
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


  Future<bool> checkUser(String email, String password, { bool isPasswordHashed=false,
        bool rememberCredentials }) async {
    const String endpoint = "/authenticate";
    // ==============================
    String hashedPassword;
    if(isPasswordHashed)
      hashedPassword=password;
    else
      hashedPassword = _hash(password);

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

    if(rememberCredentials)
      _rememberCredentials(email, hashedPassword);

    return isUserValid;
  }

  static String _hash(String password) {
    final algorithm = PBKDF2();
    String hash = Password.hash(password, algorithm);
    return hash;
  }

  Future<List<OrderRequest>> getOrderRequests() async{
    try{
      const String endpoint = "/orderRequestForSingleUser";
      // ==============================

      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Accept': 'application/json',
      };

      var uri = Uri.http(_serverAdress, endpoint); //TODO make all of queries look like this method
      http.Request request = http.Request("GET", uri);
      request.headers.addAll(_getAuthHeader());
      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await _client.send(request);
      http.Response response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode != 200) //TODO extract statusCode processing to seperate method
        throw Exception("error");

      var orderRequests = List<OrderRequest>();
      List listOfJsonObj = jsonDecode(response.body);
      for(Map jsonObj in listOfJsonObj) {
        orderRequests.add(
            OrderRequest(
              orderRequestId: jsonObj["order_request_id"],
              placedOrderId: jsonObj["placed_order_id"],
              title: jsonObj["name"],
              priceLimit: jsonObj["price_limit"],
              deadline: DateTime.parse(jsonObj["deadline"]),
              message: jsonObj["message"],
              menuUrl: jsonObj["menu_url"]
            )
        );
      }
      return orderRequests;
    }
    catch(e)
    {
      print(e); //TODO add try catch to all async because it gets swallowed otherwise
    }
  }

  ServerApi._privateCtor();
  static final ServerApi _singleton = ServerApi._privateCtor();
  factory ServerApi() => _singleton;


  Future<bool> checkSavedCredentials() async {
    bool hasLoadedSuccessfully = await _loadSavedCredentials();
    if(hasLoadedSuccessfully == false)
      return false;
    return checkUser(_email, _hashedPassword, isPasswordHashed: true, rememberCredentials: false);
  }

  Future<List<BasketEntry>> getPlacedOrder(int placedOrderId) async {
    try{
      const String endpoint = "/order";
      // ==============================

      Map<String,String> headers = {
        'Content-type' : 'application/json',
        'Accept': 'application/json',
      };

      var params = {"placed_order_id": placedOrderId.toString()};
      var uri = Uri.http(_serverAdress, endpoint, params);
      http.Request request = http.Request("GET", uri);
      request.headers.addAll(_getAuthHeader());
      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await _client.send(request);
      http.Response response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode != 200) //TODO extract statusCode processing to seperate method
        throw Exception("error");

      var order = List<BasketEntry>();
      List listOfJsonObj = jsonDecode(response.body);
      for(Map jsonObj in listOfJsonObj) {
        order.add(
            BasketEntry(
                jsonObj["food_name"],
                jsonObj["price"],
                jsonObj["quantity"],
                jsonObj["comment"])
        );
      }
      return order;
    }
    catch(e)
    {
      print(e); //TODO add try catch to all async because it gets swallowed otherwise
    }
  }

  void _rememberCredentials(String email, String hashedPassword) async {
    File credFile = await File(await _rememberedCredentialsFilePath).create();
    String content = email + " " + hashedPassword;
    credFile.writeAsString(content);
  }

  Future<bool> _loadSavedCredentials() async {
    bool fileExists = FileSystemEntity.typeSync(await _rememberedCredentialsFilePath) != FileSystemEntityType.notFound;
    
    if(fileExists == false)
      return false;
    
    File credFile = File(await _rememberedCredentialsFilePath);
    List<String> content = (await credFile.readAsString()).split(" ");
    _email = content[0];
    _hashedPassword = content[1];

    return true;
  }

  void _removeSavedCredentials() => _rememberCredentials("","");

  void logout() {
    _email = "";
    _hashedPassword = "";
    _removeSavedCredentials();
  }
}