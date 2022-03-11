import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';

void main () {
  runApp ( const MyAttestationWorkApp () );
}

class MyAttestationWorkApp extends StatelessWidget {
  const MyAttestationWorkApp ( { Key? key } ) : super ( key: key );

  @override
  Widget build ( BuildContext context ) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      initialRoute: "/auth",
      routes: {
        "/auth" : (context) => AuthScreen (),
        "/main" : (context) => const MainScreen (),
      },
    );
  }
}