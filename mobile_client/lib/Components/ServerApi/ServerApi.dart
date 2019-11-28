import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lunch_it/DataModels/MealModel.dart';
import 'package:lunch_it/DataModels/OrderResponseModel.dart';
import 'package:lunch_it/DataModels/OrderRequestModel.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:password/password.dart';
import 'package:path_provider/path_provider.dart';

enum Method {
  POST,
  GET,
  PUT,
  PATCH,
  DELETE,
}

String _hashIsolateHelper(String password) => Password.hash(password, PBKDF2());

class ServerApi
{
  Future<String> getAsText(File imageFile) => compute(_getAsText, imageFile);
  static Future<String> _getAsText(File imageFile) async {
    String endpoint = "/api/image_to_text";
    String method = "POST";
    // ==============================

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.http(_serverAdress, endpoint);
    var request = http.MultipartRequest(method, uri);

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    http.StreamedResponse streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);

    final Map responseJson = json.decode(response.body);

    if(responseJson.containsKey("error"))
      throw Exception(responseJson["error"]);

    return responseJson["text"];
  }

  Future<bool> placeOrder(OrderResponseModel order) async {
    http.Response response = await _sendJsonRequest(
      endpoint: '/api/order',
      method: Method.POST,
      body: jsonEncode(order),
      sendWithAuthHeader: true,
    );

    return response.statusCode == 200;
  }

  Future<bool> logIn(String email, String password, { bool isPasswordHashed=false,
    bool rememberCredentials }) async {


    if(isPasswordHashed == false)
      password = await _hash(password);

    http.Response response = await _sendJsonRequest(
      endpoint: '/api/authenticate',
      method: Method.POST,
      sendWithAuthHeader: false,
      body: jsonEncode({
        "user_id": email,
        "hashed_password": password,
      }),
    );

    final responseJson = json.decode(response.body);

    bool hasLoggedIn = responseJson['authenticated'] == true;

    if(hasLoggedIn) { // save for future calls
      _loginCompleter.complete();
      _email = email;
      _hashedPassword = password;
    }

    if(rememberCredentials)
      _rememberCredentials(email, password);

    return hasLoggedIn;
  }

  void _rememberCredentials(String email, String password) async {
    File credFile = await File(await _rememberedCredentialsFilePath).create();
    String content = email + " " + _hashedPassword;
    credFile.writeAsString(content);
  }

  Future<List<OrderRequestModel>> getOrderRequestsForCurrentUser() async{
    http.Response response = await _sendJsonRequest(
      endpoint: '/api/user_order_requests',
      method: Method.GET,
      sendWithAuthHeader: true,
    );

    if(response.statusCode != 200)
      throw Exception("error");

    var orderRequests = List<OrderRequestModel>();
    var responseDecoded = jsonDecode(response.body);
    for(Map parsedJsonObj in responseDecoded)
      orderRequests.add(OrderRequestModel.fromJsonMap(parsedJsonObj));

    return orderRequests;
  }

  Future<bool> checkSavedCredentials() async {
    bool hasLoadedSuccessfully = await _loadSavedCredentials();
    if(hasLoadedSuccessfully == false)
      return false;
    return logIn(_email, _hashedPassword, isPasswordHashed: true, rememberCredentials: false);
  }

  Future<List<MealModel>> getPlacedOrder(int id) async {
    http.Response response = await _sendJsonRequest(
      endpoint: '/api/order',
      method: Method.GET,
      queryParameters: {
        "placed_order_id": id.toString()
      },
      sendWithAuthHeader: true,
    );

    if(response.statusCode != 200)
      throw Exception("error");

    var order = List<MealModel>();
    List listOfJsonObj = jsonDecode(response.body);
    for(Map jsonObj in listOfJsonObj)
      order.add(MealModel.fromJsonMap(jsonObj));

    return order;
  }


  void logout() {
    _loginCompleter = Completer<void>();
    _email = "";
    _hashedPassword = "";
    _removeSavedCredentials();
  }

  Future<bool> registerUser(String email, String password) async {
    http.Response response = await _sendJsonRequest(
        endpoint: '/api/create_account',
        method: Method.GET,
        sendWithAuthHeader: true,
        body: jsonEncode({
          "user_id": email,
          "hashed_password": _hash(password),
        })
    );

    final responseJson = json.decode(response.body);
    bool hasCreatedUser = responseJson['status'] == "created";

    return hasCreatedUser;
  }

  Future<bool> hasOrdered(int orderRequestId) async {
    http.Response response = await _sendJsonRequest(
      endpoint: '/api/has_ordered',
      method: Method.GET,
      sendWithAuthHeader: true,
      queryParameters: {"order_request_id": orderRequestId.toString()},
    );

    final responseJson = json.decode(response.body);
    bool hasOrdered = responseJson['has_ordered'] == "true";

    return hasOrdered;
  }

  void closeConnection() {
    _client.close();
  }

  factory ServerApi() => _singleton;

  // private methods and fields

  String _email;
  String _hashedPassword;
  static String _serverAdress = "10.0.2.2:5002";
  final http.Client _client = http.Client();

  ServerApi._privateCtor();
  static final ServerApi _singleton = ServerApi._privateCtor();

  Future<String> get _rememberedCredentialsFilePath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String credFileName = "cred.txt";
    return appDocDir.path + "/" + credFileName;
  }

  Map<String, String> _getAuthHeader() {
    var authHeader = Map<String, String>.from({'authorization': "$_email:$_hashedPassword"});
    return authHeader;
  }

  Future<http.Response> _sendJsonRequest(
      { @required String endpoint,
        @required Method method,
        String body,
        Map<String, String> queryParameters,
        @required bool sendWithAuthHeader,
      }) async {

    var methodToString = {
      Method.POST: "POST",
      Method.GET: "GET",
    };

    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    Uri uri;
    if(queryParameters == null)
      uri = Uri.http(_serverAdress, endpoint);
    else
      uri = Uri.http(_serverAdress, endpoint, queryParameters);

    http.Request request = http.Request(methodToString[method], uri);

    if(sendWithAuthHeader)
      request.headers.addAll(_getAuthHeader());

    request.headers.addAll(headers);
    if(body != null) request.body = body;

    http.StreamedResponse streamedResponse = await _client.send(request);
    http.Response response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future<String> _hash(String password) => compute(_hashIsolateHelper, password);

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

  Completer<void> _loginCompleter = Completer<void>();
  Future<void> get loggedInFuture => _loginCompleter.future;
}