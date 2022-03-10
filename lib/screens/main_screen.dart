import 'package:attestation_work_flutter/screens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data_classes.dart';
import 'auth_screen.dart';
// import '../stubs.dart'; // для отладки в режиме отсутствия доступа к Интернету

Future <List<User>> fetchUsers () async {
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

List<User> createUserList ( List data ) {
  List<User> list = [];
  for ( int i = 0; i < data.length; i++ ) {
    User? user = User.fromJson ( data[i] );
    list.add ( user );
  }
  return list;
}

class MainScreen extends StatefulWidget {
  const MainScreen ( { Key? key } ) : super ( key: key );

  @override
  _MainScreenState createState () => _MainScreenState ();
}
class _MainScreenState extends State<MainScreen> {
  late Future<List<User>> futureUsers;
  late User lastUser;
  // = const User ( id: 1, username: "", name: "",email: "", phone: "",
  //     company: Company(name: "", catchPhrase: "", bs: ""), website: "",
  //     address: Address(city: "", zipcode: "",street: "",suite: "", geo: Geo(lat: "", lng: "")));

  ListTile _item ( BuildContext context, int index, dynamic snapshot ){
    // цвета элементов ListTile
    const TextStyle _emailStyle    = TextStyle ( color: Colors.blueGrey );  //для свойства subtitle
    const TextStyle _userNameStyle = TextStyle ( color: Colors.indigo   );  //для свойства title
    const TextStyle _idStyle       = TextStyle ( color: Colors.black38  );  //для свойства trailing
    return ListTile (
      leading: CircleAvatar (
        child: Text ( snapshot.data! [ index ].username [ 0 ] ),
      ),
        title: Text ( snapshot.data! [ index ].username,  style: _userNameStyle ),
        subtitle: Text ( snapshot.data! [ index ].email,  style: _emailStyle),
      trailing: Text ( "${ snapshot.data![ index ].id }", style: _idStyle),
      onTap: (){
         setState( () {
           lastUser = snapshot.data! [ index ];
           Navigator.push ( context, MaterialPageRoute ( builder: ( context ) => UserDetailsScreen (user: snapshot.data! [ index ] ) ) );
         });

      }
    );
  }

  AppBar _appBar () => AppBar (
    title: const Text ( 'Активные пользователи' ),
    actions: [
      IconButton (
          icon: const Icon ( Icons.arrow_back ),
          tooltip: "Назад",
          onPressed:  () {
            Navigator.of ( context ).pop (); } ),
      IconButton (
          icon: const Icon ( Icons.logout ),
          tooltip: "Выйти из профиля",
          onPressed: () {
            Navigator.pushAndRemoveUntil ( context, MaterialPageRoute ( builder: ( context ) => AuthScreen () ), (route) => false ); } ),
    ]
  );

  Drawer _drawer () => Drawer (
      child: ListView(
          children: [
            TextButton ( child: const Text ( "К списку задач" ), onPressed: () {
              if ( lastUser != null ) {
                Navigator.push ( context, MaterialPageRoute (
                    builder: (context) => UserDetailsScreen ( user: lastUser ) ) );
              }
            }),
            TextButton ( child: const Text ( "Выйти из профиля" ), onPressed: () {
                Navigator.push ( context, MaterialPageRoute (
                    builder: (context) => AuthScreen () ) );
            })
          ]
      )
  );

  Center _body () => Center (
      child: FutureBuilder <List<User>> (
          future: futureUsers,
          builder: ( context, snapshot ) {
            if ( snapshot.hasData ) {
              return ListView.builder (
                  itemCount: snapshot.data!.length,
                  itemBuilder: ( context, index ) {
                    return _item ( context, index, snapshot );
                  }
              );
            } else if ( snapshot.hasError ) {
              return Text ( '${ snapshot.error }' );
            }
            return const CircularProgressIndicator ();
          }
      )
  );

  @override
  void initState () {
    super.initState ();
    futureUsers = fetchUsers ();//fetchUsersTest(); //для отладки в offline
    futureUsers.then ( (value) => lastUser = value.first );
  }

  @override
  Widget build ( BuildContext context ) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      title: "Fetch User data",
      home: Scaffold (
        appBar: _appBar (),
        body:   _body (),
        drawer: _drawer (),
      )
    );
  }
}