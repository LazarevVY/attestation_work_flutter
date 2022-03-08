import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future <List<User>> fetchUsers() async {
  const String URI = 'https://jsonplaceholder.typicode.com/users';
  final response = await http.get ( Uri.parse ( URI ) );
  if ( response.statusCode == 200 ) {
    //print(response.body);
    List responseJson = jsonDecode ( response.body );
    List <User> users = createUserList ( responseJson );////////////////////////
    return users;//jsonDecode ( response.body ) ;//User.fromJson (sonDecode ( response.body ));
  } else {
    throw Exception ( 'Failed to load album' );
  }
}

List<User> createUserList (List data) {
  List<User> list = [];
  for (int i = 0; i< data.length; i++) {
    User? user = User.fromJson( data[i] );
    list.add(user);
  }
  return list;
}
class Geo {
  final String lat;
  final String lng;

  const Geo({ required this.lat, required this.lng });

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
  final String zipcode;
  final  geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo
  });

  factory Address.fromJson (Map<String, dynamic> json) {
    return Address(
        street:  json [ 'street'  ],
        suite:   json [ 'suite'   ],
        city:    json [ 'city'    ],
        zipcode: json [ 'zipcode' ],
        geo:     Geo.fromJson(json [ 'geo'     ]),
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
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
      address:  Address.fromJson(json [ 'address' ]),
      phone:    json [ 'phone'   ],
      website:  json [ 'website' ],
      company:  Company.fromJson(json [ 'company' ]),
    );
  }
}

void main() {
  runApp(const MyAttestationWorkApp());
}

class MyAttestationWorkApp extends StatelessWidget {
  const MyAttestationWorkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/main",
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


// Column test = Column(
//   children: [
//     Text(snapshot.data![1].username,
//         textAlign: TextAlign.center,
//         style: const TextStyle( fontSize: 32, color: Colors.indigo)),
//     const SizedBox(height: 16,),
//     Text(snapshot.data![1].address.street,
//       textAlign: TextAlign.justify,
//       style: const TextStyle( fontSize: 20, color: Colors.black45),
//     ),
//   ],
// );




class _MainScreenState extends State<MainScreen> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetch User data",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
          body: Center(
              child: FutureBuilder<List<User>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print (snapshot.data!);
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                               Text(snapshot.data![index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                              Divider()
                            ],
                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              )
          )
      ),
    );
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
