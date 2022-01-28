import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final _url = 'http://192.168.1.113:8000/api/v1';
  // 192.168.1.111 este é meu IP, altere para o seu IP
  var token;

  //recuperar o token
  _getToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('token');
    token = json.decode(userJson!)['token'];
    //token = json.decode(localStorage.getString('token'))['token'];
  }

  auth(data, apiURL) async{
    var fullUrl = Uri.parse(_url + apiURL);
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  getData(apiURL) async{
    var fullUrl = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}