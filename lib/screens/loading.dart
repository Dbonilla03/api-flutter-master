import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../services/user_service.dart';
import 'login.dart';
import 'home.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String _token = '';

  void _loadUserInfo() async {
    _token = await getToken();
    if (_token.isEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
    } else {
      ApiResponse response = await getUserDetail();
      BuildContext scaffoldContext = _scaffoldKey.currentContext!;
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
              (route) => false,
        );
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
