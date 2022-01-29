import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:inventario/env.dart';
import 'package:inventario/model/devices.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './edit.dart';

class Details extends StatefulWidget {
  final Device? device;

  Details({this.device});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  void deleteDevice(context) async {

    //Buscar na memória do dispositivo a variavel contendo o Token
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenJson = localStorage.getString('token');
    var token = json.decode(tokenJson!)['token'];
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    //deletar item aqui
    final url = Uri.parse('${Env.urlPrefix}/devices/${widget.device?.id.toString()}');
    final response = await http.delete(url,headers: headers);
    print('Codigo do status: ${response.statusCode}');
    print('Corpo: ${response.body}');


    // Navigator.pop(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Deseja realmente deletar?'),
          actions: <Widget>[
            RaisedButton(
              child: Icon(Icons.cancel),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Icon(Icons.check_circle),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => deleteDevice(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Detalhes', style: TextStyle(color: Colors.greenAccent),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Column(
                children: <Widget>[
                  Text("PATRIMÔNIO"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.patri}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("NÚMERO DE SÉRIE"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.sn}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("NOME"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.name}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("USUÁRIO"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.user}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("SETOR / DEPARTAMENTO"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.setor}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("MARCA"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.brand}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("MODELO"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.model}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("TIPO - Ex:Note,PC,Impressora.."),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.type}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("STATUS"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("${widget.device?.status}"),
                          )
                        ])
                      ],
                    ),
                  ),
                  Text("EVIDÊNCIA"),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow( children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.network("${Env.urlHost}/images/${widget.device?.image}"),
                          )
                        ])
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.edit, color: Colors.greenAccent,),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Edit(device: widget.device),
          ),
        ),
      ),
    );
  }
}