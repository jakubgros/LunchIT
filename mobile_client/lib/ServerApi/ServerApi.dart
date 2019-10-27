import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerApi
{
  String _serverAdress = "localhost:5002";

  getAsText(String filePath) async {
    String endpoint = "/getAsText";
    String method = "POST";
    // ==============================

    File imageFile = File(filePath);

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


  ServerApi._privateCtor();
  static final ServerApi _singleton = ServerApi._privateCtor();
  factory ServerApi() => _singleton;
}