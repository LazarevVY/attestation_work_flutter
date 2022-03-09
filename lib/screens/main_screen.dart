import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes.dart';


Future <List<User>> fetchUsers() async {
  const String URI = 'https://jsonplaceholder.typicode.com/users';
  final response = await http.get ( Uri.parse ( URI ) );
  if ( response.statusCode == 200 ) {
    List responseJson = jsonDecode ( response.body );
    List <User> users = createUserList ( responseJson );
    return users;
  } else {
    throw Exception ( 'Failed to load list of users from ${URI}' );
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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<User>> futureUsers;

  ListTile _item (BuildContext context, int index, dynamic snapshot){
    // цвета элементов ListTile
    const TextStyle _emailStyle = TextStyle(color: Colors.blueGrey);  //для свойства subtitle
    const TextStyle _userNameStyle = TextStyle(color: Colors.indigo); //для свойства title
    const TextStyle _idStyle = TextStyle(color: Colors.black38);      //для свойства title
    return ListTile (
      leading: const Icon(Icons.account_circle),
      subtitle: Text ( snapshot.data![index].email,
          style: _emailStyle),
      title: Text( snapshot.data![index].username,
          style: _userNameStyle),
      trailing: Text("${snapshot.data![index].id}",
          style: _idStyle),
      onTap: (){}
    );
  }

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
                          return _item(context, index, snapshot);
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