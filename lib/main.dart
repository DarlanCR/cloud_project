// ignore_for_file: library_private_types_in_public_api, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cloud_project/color.dart';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme:
          ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark()),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? bytes;
  List<int>? selectedFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _elementController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          bytes = const Base64Decoder()
              .convert(reader.result.toString().split(',').last);
          selectedFile = bytes;
        });
      });
      reader.readAsDataUrl(file);
    });
  }

  Future<void> _uploadData() async {
    if (!_formKey.currentState!.validate() || bytes == null) return;
    print('Foi');
    // Envie os dados para o servidor ou GitHub aqui
    // Você pode usar a biblioteca http para fazer uma solicitação POST, por exemplo
    // Exemplo de envio de dados:
    // final response = await http.post('sua_url_aqui', body: {
    //   'campo1': _nameController.text,
    //   'campo2': _typeController.text,
    //   'campo3': _elementController.text,
    // });

    // Se você quiser enviar a imagem junto, use MultipartRequest
    // Exemplo de envio de imagem:
    // final request = http.MultipartRequest('POST', Uri.parse('sua_url_aqui'));
    // request.files.add(await http.MultipartFile.fromPath('imagem', _image!.path));
    // request.fields['campo1'] = _nameController.text;
    // request.fields['campo2'] = _typeController.text;
    // request.fields['campo3'] = _elementController.text;
    // final response = await request.send();

    // Lembre-se de tratar a resposta do servidor ou GitHub conforme necessário

    // Limpe os campos e a imagem após o envio
    _nameController.clear();
    _typeController.clear();
    _elementController.clear();
    setState(() {
      bytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.8,
          color: const Color.fromARGB(255, 29, 29, 29),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Pokémon',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informar nome';
                            } else {
                              return null;
                            }
                          },
                          controller: _nameController,
                          decoration: inputModel('Nome'),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informar tipo';
                            } else {
                              return null;
                            }
                          },
                          controller: _typeController,
                          decoration: inputModel('Tipo'),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informar elemento';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _elementController,
                                decoration: inputModel('Elemento'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _pickImage,
                                  child: const Icon(Icons.add_a_photo_outlined),
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                ),
              ),
              bytes != null
                  ? Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Image.memory(bytes!)),
                    )
                  : Container(),
              ElevatedButton(
                  onPressed: _uploadData, child: const Text('Enviar Dados')),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration inputModel(String label) {
  return InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
  );
}
