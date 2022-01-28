import 'dart:io';
import 'dart:convert';
import 'package:inventario/model/devices.dart';
import 'package:inventario/screens/tabs/pages/tabs_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:inventario/env.dart';
import 'package:inventario/widget/form_device.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit extends StatefulWidget {
  final Device? device;

  Edit({this.device});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  File? _image;

  // This is for text onChange
  TextEditingController? patriController;
  TextEditingController? snController;
  TextEditingController? nameController;
  TextEditingController? userController;
  TextEditingController? setorController;
  TextEditingController? brandController;
  TextEditingController? modelController;
  TextEditingController? typeController;
  TextEditingController? statusController;
  TextEditingController? imageController;


  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });

  }


  // Http post request
  //VAMOS ATUALIZAR NOSSO DISPOSITIVO AQUI
  Future editProduto() async {
    //Buscar na memória do dispositivo a variavel contendo o Token
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenJson = localStorage.getString('token');
    var token = json.decode(tokenJson!)['token'];

    final headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.parse('${Env.urlPrefix}/devices_up');
    print(url);

    var request = http.MultipartRequest('POST', url);
    //HEADERS
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    //CAMPOS
    request.fields['id'] = '${widget.device!.id}';
    request.fields['patri'] = '${patriController?.text}';
    request.fields['sn'] = '${snController?.text}';
    request.fields['name'] = '${nameController?.text}';
    request.fields['user'] = '${userController?.text}';
    request.fields['setor'] = '${setorController?.text}';
    request.fields['brand'] = '${brandController?.text}';
    request.fields['model'] = '${modelController?.text}';
    request.fields['type'] = '${typeController?.text}';
    request.fields['status'] = '${statusController?.text}';

    print(widget.device!.id);



    if(_image == null){
      request.fields['image'] = '';
    }else{
      var pic = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(pic);
    }


    var response = await request.send();

    print(response);


  }

  void _onConfirm(context) async {
    await editProduto();
    /*Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
     */
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => TabsPage()
      ),
    );
  }

  @override
  void initState() {
    patriController = TextEditingController(text: widget.device?.patri);
    snController = TextEditingController(text: widget.device?.sn);
    nameController = TextEditingController(text: widget.device?.name);
    userController = TextEditingController(text: widget.device?.user);
    setorController = TextEditingController(text: widget.device?.setor);
    brandController = TextEditingController(text: widget.device?.brand);
    modelController = TextEditingController(text: widget.device?.model);
    typeController = TextEditingController(text: widget.device?.type);
    statusController = TextEditingController(text: widget.device?.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: ButtonTheme(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: RaisedButton(
                onPressed: () {
                  _onConfirm(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(Icons.visibility, color: Colors.white,),
                    Text("ATUALIZAR", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),
          ),

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


              if(_image == null)
                Container(
                  width: 250.0,
                  height: 250.0,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network("${Env.urlHost}/images/${widget.device?.image}"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),
              if(_image != null)
                Container(
                  width: 250.0,
                  height: 250.0,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(_image!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),

              TextButton(
                child: Text("MUDAR IMAGEM"),
                onPressed: () {
                  getImage();
                },
              ),


            ],
          ),
        )
    );
  }
  /*
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('descController', descController));
  }
  */
}