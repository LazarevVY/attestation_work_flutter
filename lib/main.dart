import 'package:flutter/material.dart';

void main() {
  runApp(const MyAttestationWorkApp());
}

class Geo {
  final String lat;
  final String lng;

  Geo({ required this.lat, required this.lng });

  factory Geo.fromJson (Map<String, dynamic> json) {
    return Geo (
      lat: json ['lat'],
      lng: json ['lng']
    );
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.geo
  });

  factory Address.fromJson (Map<String, dynamic> json) {
    return Address(
        street: json [ 'street' ],
        suite:  json [ 'suite' ],
        city:   json [ 'city' ],
        geo:    json [ 'geo' ]
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs
  });

  factory Company.fromJson (Map<String, dynamic> json) {
    return Company(
      name:        json [ 'name' ],
      catchPhrase: json [ 'catchPhrase' ],
      bs:          json [ 'bs' ]
    );
  }
}
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Address address;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:       json [ 'id'      ],
      name:     json [ 'name'    ],
      username: json [ 'username'],
      email:    json [ 'email'   ],
      address:  json [ 'address' ],
      phone:    json [ 'phone'   ],
      website:  json [ 'website' ],
      company:  json [ 'company' ]
    );
  }
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
        "/details" : (context) => UserDetailsScreen()
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  final String userPhone = "9871234567";
  final String userPass  = "P@s\$w0rd";


  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AppBar _AuthScreenAppBar = AppBar(
    title: Text("Аттестационная работа")
  );

  Drawer _AuthScreenDrawer = Drawer(
    backgroundColor: Colors.blue,
    child: Column(
      children: [
        Text("12345"),
      ],
    ),
  );

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _AuthScreenAppBar,
        drawer: _AuthScreenDrawer,
        body: Container(
          child: Column(
            children: const [
              SizedBox(height: 300,),
              Text("Введите данные для входа"),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
