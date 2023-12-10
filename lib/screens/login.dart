import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../services/user_service.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;
  String? errorMessage;

  void _loginUser() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    ApiResponse response = await login(txtEmail.text, txtPassword.text);

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      _saveAndRedirectToHome();
    } else {
      setState(() {
        errorMessage = response.error;
      });
    }
  }

  void _saveAndRedirectToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 250,
                      child: Image.asset("assets/bienestar.png", fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      validator: (val) =>
                      val!.isEmpty ? 'Invalid email address' : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail),
                        contentPadding:
                        const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      obscureText: true,
                      controller: txtPassword,
                      validator: (val) =>
                      val!.isEmpty ? 'Invalid password' : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open),
                        contentPadding:
                        const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    loading
                        ? Center(child: CircularProgressIndicator())
                        : kTextButton('Login', () {
                      if (formKey.currentState!.validate()) {
                        _loginUser();
                      }
                    }),
                    const SizedBox(height: 15),
                    errorMessage != null
                        ? Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
