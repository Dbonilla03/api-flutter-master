// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseURL = 'http://192.168.18.2:8000/api';
const loginURL = baseURL + '/SIGAC/login';
const logoutURL = baseURL + '/SIGAC/logout';
const apprenticesURL = baseURL + '/SIGAC/apprentice';
const assistenceURL = baseURL + '/SIGAC/assistence';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';


// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),

    );
}

//Header Login
Container HeaderLogin (){
  return Container(
      color: Colors.green,
      height: 300,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      )
  );
}

// button
Container kTextButton(String label, Function onPressed) {
  return Container(
    width: 500,
    child: TextButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.fromLTRB(20, 20, 20, 20),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
//Appbar
AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: SizedBox(
      child: Image.asset("assets/bienestar.png", fit: BoxFit.contain),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.notifications, color: Colors.green,),
        onPressed: () {
          // Aquí puedes abrir una nueva pantalla o mostrar las notificaciones
          // Puedes implementar la lógica para mostrar las notificaciones aquí
          // o navegar a una nueva pantalla donde se muestren las notificaciones.
        },
      ),
    ],
  );
}


// loginHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style:TextStyle(color: Colors.green)),
        onTap: () => onTap()
      )
    ],
  );
}
