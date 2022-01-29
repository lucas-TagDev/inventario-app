import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventario/env.dart';
import 'package:inventario/widget/form_device.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Create extends StatefulWidget {

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  // Required for form validations
  final formKey = GlobalKey<FormState>();

  ///Guardar valor do Codigo Barras
  late String _codebar;
  String _value = "";



  /// Campos do formulario
  TextEditingController patriController = new TextEditingController(); //new TextEditingController(text: ''); //
  TextEditingController snController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController userController = new TextEditingController();
  TextEditingController setorController = new TextEditingController();
  TextEditingController brandController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();

  ///propriedades do arquivo de imagem
  String status = '';
  String errMessage = 'Erro ao tentar fazer upload';
  final picker = ImagePicker();
  File? _image;

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  ///Funcao para chamar leitor de codigo de barras
  Future _codScanner() async{
    _codebar = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.DEFAULT);

    setState(() {
      patriController.text = _codebar;
    });
  }

  ///Funcao para pegar imagem da galeria
  Future _getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    print('kkkkk');
    setState(() {
      _image = File(image!.path);
    });
  }

  ///Enviar informacoes para o nosso endpoit (BACKEND)

  Future _createDevice() async {
    //Buscar na memória do dispositivo a variavel contendo o Token
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenJson = localStorage.getString('token');
    var token = json.decode(tokenJson!)['token'];
    //print(token);



    //final headers = {"Content-type": "application/json"};
    final url = Uri.parse('${Env.urlPrefix}/devices');

    print(_image);
    var request = http.MultipartRequest('POST', url);
    //HEADER/CABECALHO
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    //FIELDS/CAMPOS
    request.fields['patri'] = patriController.text;
    request.fields['sn'] = snController.text;
    request.fields['name'] = nameController.text;
    request.fields['user'] = userController.text;
    request.fields['setor'] = setorController.text;
    request.fields['brand'] = brandController.text;
    request.fields['model'] = modelController.text;
    request.fields['type'] = typeController.text;
    request.fields['status'] = statusController.text;
    //var pic = await http.MultipartFile.fromPath("image", _image!.path);

    if(_image == null){
      request.fields['image'] = '';
    }else{
      var pic = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(pic);
    }
    print(request);
    var response = await request.send();
    //printa o corpo do response para saber detalhes da requisicao
    final respStr = await response.stream.bytesToString();

    print(respStr);

    if(response.statusCode == 200){
      print('imagem enviada com sucesso');
    }else{
      print('erro ao enviar imagem');
      print(response);
    }

  }

  void _onConfirm(context) async {
    await _createDevice();

    // Retornar mesmo após inserir ou não os dados
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Criar", style: TextStyle(color: Colors.greenAccent),),
        ),

        bottomNavigationBar: BottomAppBar(
            child:
            Padding(
              padding: EdgeInsets.all(30),
              child: ButtonTheme(
                buttonColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: RaisedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _onConfirm(context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_outlined, color: Colors.greenAccent,),
                      Text("CADASTRAR", style: TextStyle(color: Colors.greenAccent),)
                    ],
                  ),
                ),
              ),
            )
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: AppForm(
                    formKey: formKey,
                    patriController: patriController,
                    snController: snController,
                    nameController: nameController,
                    userController: userController,
                    setorController: setorController,
                    brandController: brandController,
                    modelController: modelController,
                    typeController: typeController,
                    statusController: statusController,
                  ),
                ),
              ),

              IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  _getImage();
                },
              ),
              Container(
                child: _image == null ? Text('* Foto do Equipamento') : Image.file(_image!),
              ),

              SizedBox(
                height: 20.0,
              ),
              //showImage(),
              SizedBox(
                height: 20.0,
              ),

              SizedBox(
                height: 20.0,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _codScanner,
        tooltip: 'Scanear Codigo',
        child: Icon(Icons.settings_overscan, color: Colors.greenAccent,),
      ),
    );
  }

}