import 'dart:async';
import 'dart:convert';

import 'package:inventario/network/api.dart';
import 'package:inventario/network/search_api.dart';
import 'package:inventario/model/devices.dart';
import 'package:inventario/screens/create.dart';
import 'package:inventario/screens/detalhes.dart';
import 'package:inventario/screens/login.dart';
import 'package:inventario/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:inventario/env.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Device> devices = [];
  String query = '';
  Timer? debouncer;

  ///Guardar valor do Codigo Barras
  late String _codebar;
  String _value = "";

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  ///Utilizamos debounce para evitar o disparo de várias requisições ao nosso servidor
  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  ///Funcao para chamar leitor de codigo de barras
  Future _codScanner() async{
    _codebar = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.DEFAULT);

    setState(() {
      query = _codebar;
      init();
    });
  }

  Future init() async {
    final devices = await DeviceApi.getDevices(query);

    setState(() => this.devices = devices);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: Text("Inventário", style: TextStyle(color: Colors.greenAccent),),
      actions: [
        IconButton(
          icon: Icon(Icons.power_settings_new),
          onPressed: (){
            logout();
          },
        )
      ],
      centerTitle: true,
    ),
    body: Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];

              return buildBook(device);
            },
          ),
        ),
      ],
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Stack(
      fit: StackFit.expand,
      children: [
        /*
        Positioned(
          left: 30,
          bottom: 20,
          child: FloatingActionButton(
            heroTag: 'back',
            onPressed: () {
              _codScanner();
            },
            child: const Icon(
              Icons.qr_code_scanner_outlined,
              size: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),*/
        Positioned(
          bottom: 20,
          right: 30,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: 'next',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Create();
              }));
            },
            child: const Icon(
              Icons.add,
              color: Colors.greenAccent,
              size: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Add more floating buttons if you want
        // There is no limit
      ],
    ),


  );

  //Fazer Logout
  void logout() async{
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Nome ou Patrimonial',
    onChanged: searchBook,
  );

  Future searchBook(String query) async => debounce(() async {
    final devices = await DeviceApi.getDevices(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.devices = devices;
    });
  });

  Widget buildBook(Device device) => ListTile(
    leading: Image.network(
      '${Env.urlHost}/images/${device.image}',
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    ),
    title: Text(device.name.toString()),
    subtitle: Text(device.patri.toString()),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Details(device: device)),
      );
    },
  );
}

