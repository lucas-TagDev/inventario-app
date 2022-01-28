import 'dart:convert';

import 'package:inventario/model/devices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/env.dart';

class DeviceApi {


  static Future<List<Device>> getDevices(String query) async {
    final url = Uri.parse("${Env.urlPrefix}/devices");

    //Buscar na memória do dispositivo a variavel contendo o Token
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenJson = localStorage.getString('token');
    var token = json.decode(tokenJson!)['token'];
    //print(token);

    //Passar o token para o laravel pelo Header
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List devices = json.decode(response.body);

      return devices.map((json) => Device.fromJson(json)).where((device) {
        final titleLower = device.name!.toLowerCase();
        final authorLower = device.patri!.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            authorLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}