// Importa las bibliotecas necesarias
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constant.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _documentController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  // Método para realizar la búsqueda
  void _searchPerson() async {
    if (_documentController.text.isNotEmpty) {
      final response = await http.get(
        Uri.parse('$apprenticesURL?document_number=${_documentController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          searchResults = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Manejar errores aquí
      }
    }
  }

  // Método para guardar la información de la persona
  void _savePerson(Map<String, dynamic> personData) async {
    try {

      final response = await http.post(
        Uri.parse('$assistenceURL?'
            'document_number=${personData['document_number']}&'
            'first_name=${personData['first_name']}&'
            'first_last_name=${personData['first_last_name']}&'
            'second_last_name=${personData['second_last_name']}&'
            'code=${personData['code']}&'
            'name=${personData['name']}&'
            'date=${Uri.encodeComponent(DateTime.now().toString())}'),
      );

      if (response.statusCode == 200) {
        // Éxito, la información se guardó correctamente
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Guardar Información"),
              content: Text("La información se guardó correctamente."),
              actions: [
                TextButton(
                  child: Text("Cerrar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Manejar errores aquí
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error al Guardar Información"),
              content: Text("No se pudo guardar la información."),
              actions: [
                TextButton(
                  child: Text("Cerrar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Manejar errores de conexión aquí
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error de Conexión"),
            content: Text("No se pudo conectar al servidor.",),
            actions: [
              TextButton(
                child: Text("Cerrar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _documentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número de Documento',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchPerson,
                  ),
                ],
              ),
              SizedBox(height: 30),
              for (var result in searchResults)
                if (result != null && result is Map<String, dynamic>)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result.containsKey('document_number'))
                        Text('Documento: ${result['document_number']}'),
                      if (result.containsKey('first_name'))
                        Text('Nombre: ${result['first_name']}'),
                      if (result.containsKey('first_last_name'))
                        Text('Primer Apellido: ${result['first_last_name']}'),
                      if (result.containsKey('second_last_name'))
                        Text('Segundo Apellido: ${result['second_last_name']}'),
                      if (result.containsKey('code'))
                        Text('Código del Curso: ${result['code']}'),
                      if (result.containsKey('name'))
                        Text('Programa: ${result['name']}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _savePerson(result), // Llama al método _savePerson con los datos de la persona
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
