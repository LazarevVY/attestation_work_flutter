import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'screens/user_details_screen.dart';

void main() {
  runApp(const MyAttestationWorkApp());
}

class MyAttestationWorkApp extends StatelessWidget {
  const MyAttestationWorkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/" :     (context) => AuthScreen(),
        "/main" : (context) => MainScreen(),
        //"/details" : (context) => UserDetailsScreen()
      },
    );
  }
}