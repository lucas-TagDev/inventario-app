import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class AppForm extends StatefulWidget {
  // Required for form validations
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  // Handles text onchange
  TextEditingController? patriController;
  TextEditingController? snController;
  TextEditingController? nameController;
  TextEditingController? userController;
  TextEditingController? setorController;
  TextEditingController? brandController;
  TextEditingController? modelController;
  TextEditingController? typeController;
  TextEditingController? statusController;

  AppForm({this.formKey, this.patriController, this.snController, this.nameController, this.userController, this.setorController
    , this.brandController, this.modelController, this.typeController, this.statusController});

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  String? _validateName(String? value) {
    if (value!.length < 3) return 'Nome do dispositivo precisa de pelo menos 2 caractere';
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always, key: widget.formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.patriController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Patrimonial'),
          ),
          TextFormField(
            controller: widget.snController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Numero de Série'),
          ),
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: _validateName,
          ),
          TextFormField(
            controller: widget.userController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Usuário'),
          ),
          TextFormField(
            controller: widget.setorController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Setor/Departamento'),
          ),
          TextFormField(
            controller: widget.brandController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Marca'),
          ),
          TextFormField(
            controller: widget.modelController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Modelo'),
          ),
          TextFormField(
            controller: widget.typeController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Tipo'),
          ),
          TextFormField(
            controller: widget.statusController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Status'),
          ),

        ],
      ),
    );
  }
}