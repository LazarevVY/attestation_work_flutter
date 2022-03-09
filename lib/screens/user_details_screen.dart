import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data_classes.dart';
//import '../stubs.dart'; // для отладки в режиме отсутствия доступа к Интернету

Future <List<Todos>> fetchTodos ( int userId ) async {
  final String URI = 'https://jsonplaceholder.typicode.com/todos?userId=${userId}';
  final response = await http.get ( Uri.parse ( URI ) );
  if ( response.statusCode == 200 ) {
    List responseJson = jsonDecode ( response.body );
    List <Todos> todos = createTodosList ( responseJson );
    return todos;
  } else {
    throw Exception ( 'Failed to load list of users from ${URI}' );
  }
}

List<Todos> createTodosList ( List data ) {
  List<Todos> list = [];
  for ( int i = 0; i < data.length; i++ ) {
    Todos? todos = Todos.fromJson ( data [ i ] );
    list.add ( todos );
  }
  return list;
}

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen ( { Key? key, required this.user } ) : super ( key: key );
  User user;
  @override
  _UserDetailsScreenState createState () => _UserDetailsScreenState ();
}
class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Future<List<Todos>> futureTodos;

  ListTile _item ( BuildContext context, int index, dynamic snapshot ) {
    return ListTile (
           title: Text ( snapshot.data! [ index ].title,
            style: const TextStyle ( color: Colors.indigo ) ),
        subtitle: Text ( "${ snapshot.data! [ index ].id }" ),
        trailing: snapshot.data! [ index ].completed ?
                    const Icon ( Icons.check_box_outlined, size: 16, color: Color.fromRGBO ( 0, 255, 0, 1.0 ) )
                  : const Text ( "" )
    );
  }

  @override
  void initState () {
    super.initState ();
    futureTodos = fetchTodos ( widget.user.id ); //fetchTodosTest(widget.user.id); //для отладки в offline
  }

  @override
  Widget build ( BuildContext context ) {
    final _tabPages = <Widget>[
      Center(                            ///////////////// Подробности про User //////////////////
          child: ListView (
            children: [
              //ListTile ( title: Text ( "${widget.user.id}"  ), subtitle: const Text ( "id"      ) ),
              ListTile ( title: Text ( widget.user.name     ), subtitle: const Text ( "name"    ) ),
              ListTile ( title: Text ( widget.user.username ), subtitle: const Text ( "userName") ),
              ListTile ( title: Text ( widget.user.phone    ), subtitle: const Text ( "phone"   ), leading: const Icon ( Icons.phone ) ),
              ListTile ( title: Text ( widget.user.email    ), subtitle: const Text ( "e-mail"  ), leading: const Icon ( Icons.alternate_email ) ),
              ListTile ( title: Text ( widget.user.website  ), subtitle: const Text ( "website" ), leading: const Icon ( Icons.phonelink_outlined ) ),
              ExpansionTile (
                leading: Icon ( Icons.account_balance ),
                title: Text ( "ADDRESS" ),
                children: [
                  ListTile ( title: Text ( widget.user.address.street  ), subtitle: const Text ( "street" ) ),
                  ListTile ( title: Text ( widget.user.address.suite   ), subtitle: const Text ( "suite"  ) ),
                  ListTile ( title: Text ( widget.user.address.city    ), subtitle: const Text ( "city"   ) ),
                  ListTile ( title: Text ( widget.user.address.zipcode ), subtitle: const Text ( "zipcode") ),
                  ListTile ( title: Text ( widget.user.address.geo.lat ), subtitle: const Text ( "lat"    ) ),
                  ListTile ( title: Text ( widget.user.address.geo.lng ), subtitle: const Text ( "lng"    ) ),
                ],
              ),
              ExpansionTile (
                leading: Icon ( Icons.addchart ),
                  title: Text ( "COMPANY" ),
                children: [
                  ListTile ( title: Text ( widget.user.company.name       ), subtitle: const Text ( "name"        ) ),
                  ListTile ( title: Text ( widget.user.company.bs         ), subtitle: const Text ( "bs"          ) ),
                  ListTile ( title: Text ( widget.user.company.catchPhrase), subtitle: const Text ( "catchPhrase" ) )
                ],
              )
            ],
          )
      ),
      Center (                         /////////////// Формирование списка задач ///////////////
          child: FutureBuilder <List<Todos>> (
              future: futureTodos,
              builder: ( context, snapshot ) {
                if ( snapshot.hasData ) {
                  return ListView.builder (
                      itemCount: snapshot.data!.length,
                      itemBuilder: ( context, index ) {
                        return _item( context, index, snapshot );
                      }
                  );
                } else if ( snapshot.hasError ) {
                  return Text ( '${snapshot.error}' );
                }
                return const CircularProgressIndicator ();
              }
          )
      )
    ];
    /////////////////////////////////// Меню из вкладок ///////////////////////////////
    final _tabHeaders = <Tab> [
      const Tab ( icon: Icon ( Icons.account_box_rounded), text: 'О пользователе' ),
      const Tab ( icon: Icon ( Icons.list               ), text: 'Задачи' )
    ];
    return DefaultTabController (
        length: _tabHeaders.length,
        child: Scaffold (
          appBar: AppBar (
            title: const Text ( "Детали" ),
            backgroundColor: Colors.cyan,
            bottom: TabBar ( tabs: _tabHeaders ),
          ),
          body: TabBarView ( children: _tabPages ),
    )
    );
  }
}