import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    switch (response.statusCode) {
      case 200:
        User user = User.fromJson(jsonDecode(response.body));
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('token', user.token ?? '');
        await pref.setString('email', email);
        await pref.setString('password', password);
        apiResponse.data = user;
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = await getToken();
    String email = pref.getString('email') ?? '';
    String password = pref.getString('password') ?? '';

    final response = await http.get(
      Uri.parse(apprenticesURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        ApiResponse loginResponse = await login(email, password);
        if (loginResponse.error == null) {
          apiResponse = await getUserDetail();
        } else {
          apiResponse.error = unauthorized;
        }
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> updateUser(String name) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(apprenticesURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {'name': name},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        String email = await getEmail();
        String password = await getPassword();
        ApiResponse loginResponse = await login(email, password);
        if (loginResponse.error == null) {
          apiResponse = await updateUser(name);
        } else {
          apiResponse.error = unauthorized;
        }
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}


// Obtiene el token almacenado
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// Obtiene el ID de usuario almacenado
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// Cierra la sesión y elimina el token
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
// Obtiene el correo almacenado
Future<String> getEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email') ?? '';
}

// Obtiene la contraseña almacenada
Future<String> getPassword() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('password') ?? '';
}
