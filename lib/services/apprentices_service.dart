import 'dart:convert';
import '../services/user_service.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;


//Aprendices
class UserService {
  static Future<List<String>> fetchApprentices() async {
    try {
      String token = await getToken();
      final response = await http.get(
          Uri.parse(apprenticesURL),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> apprenticeNames = data.map((item) => item['id'] as String).toList();

        return apprenticeNames;
      } else {
        throw Exception('Error al obtener los aprendices');
      }
    } catch (error) {
      throw Exception('Error de conexión: $error');
    }
  }
}
