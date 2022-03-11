import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data_classes.dart';
import 'main_screen.dart';
import 'auth_screen.dart';
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

  int _nTotalUserTasks =0 ;
  int _nCompletedUserTasks =0;

  ListTile _item ( BuildContext context, int index, dynamic snapshot ) {
    Color _flagColor = const Color ( 0x3F51B580 );
    void _changeChecks ( bool? val ) {
      setState(() {
        snapshot.data [ index ].completed = val;
        _flagColor = Color ( 0x00cc00f0);
      });
    }
    if ( snapshot.data! [ index ].completed ) { _nCompletedUserTasks ++ ;}
    return ListTile (
           title: Text ( snapshot.data! [ index ].title,
            style: const TextStyle ( color: Colors.indigo ) ),
        subtitle: Text ( "${ snapshot.data! [ index ].id }" ),
        trailing: Checkbox (
            value: snapshot.data [ index ].completed,
            activeColor: _flagColor,
            onChanged: _changeChecks
            )
    );
  }

   _tabPages ()  => [
    Center (                         /////////////// Формирование списка задач ///////////////
        child: FutureBuilder <List<Todos>> (
            future: futureTodos,
            builder: ( context, snapshot ) {
              if ( snapshot.hasData ) {
                _nTotalUserTasks = snapshot.data!.length;
                return ListView.builder (
                    itemCount: _nTotalUserTasks, //snapshot.data!.length,
                    itemBuilder: ( context, index ) {
                      if ( snapshot.data! [ index ].completed ) { _nCompletedUserTasks ++; }
                      return _item( context, index, snapshot );
                    }
                );
              } else if ( snapshot.hasError ) {
                return Text ( '${snapshot.error}' );
              }
              return const CircularProgressIndicator ();
            }
        )
    ),
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
              leading: const Icon ( Icons.account_balance ),
              title:   const Text ( "ADDRESS" ),
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
              leading: const Icon ( Icons.addchart ),
              title:   const Text ( "COMPANY" ),
              children: [
                ListTile ( title: Text ( widget.user.company.name       ), subtitle: const Text ( "name"        ) ),
                ListTile ( title: Text ( widget.user.company.bs         ), subtitle: const Text ( "bs"          ) ),
                ListTile ( title: Text ( widget.user.company.catchPhrase), subtitle: const Text ( "catchPhrase" ) )
              ],
            )
          ],
        )
    ),

  ];

  /////////////////////////////////// Меню из вкладок ///////////////////////////////
  final _tabHeaders = <Tab> [
    const Tab ( icon: Icon ( Icons.list               ), text: 'Задачи' ),
    const Tab ( icon: Icon ( Icons.account_box_rounded), text: 'О пользователе' ),
  ];

  AppBar _appBar () => AppBar (
    title: const Text ( "Детали" ),
    backgroundColor: Colors.cyan,
    actions: [
      IconButton (
          icon: const Icon ( Icons.arrow_back ),
          tooltip: "К списку пользователей",
          onPressed:  () {
            Navigator.push ( context, MaterialPageRoute ( builder: ( context ) => MainScreen () ) ); } ),
      IconButton (
          icon: const Icon ( Icons.logout ),
          tooltip: "Выйти из профиля",
          onPressed: () {
            Navigator.pushAndRemoveUntil ( context, MaterialPageRoute ( builder: ( context ) => AuthScreen () ), (route) => false ); } ),
    ],
    bottom: TabBar ( tabs: _tabHeaders ),
  );

  Drawer _drawer () => Drawer(
    child: ListView(
      children: [
        ListTile ( subtitle: const Text ( "userName" ), title: Text ( widget.user.username  , style: const TextStyle ( fontSize: 24) ) ),
        ListTile ( subtitle: const Text ( "phone"    ), title: Text ( widget.user.phone    ), leading: const Icon ( Icons.phone ) ),
        ListTile ( subtitle: const Text ( "e-mail"   ), title: Text ( widget.user.email    ), leading: const Icon ( Icons.alternate_email ) ),
        const Divider (),
        //ListTile ( title: Text ( "$_nCompletedUserTasks" ) ),
        TextButton ( child: const Text ("К списку пользователей"), onPressed: () {
          Navigator.push ( context, MaterialPageRoute ( builder: ( context ) => MainScreen () ) );
        }),
        TextButton ( child: const Text ( "Выйти из профиля" ), onPressed: () {
          Navigator.push ( context, MaterialPageRoute (
              builder: ( context ) => AuthScreen () ) );
        })
      ],
    ),
  );

  @override
  void initState () {
    super.initState ();
    futureTodos = fetchTodos ( widget.user.id ); //fetchTodosTest(widget.user.id); //для отладки в offline
  }

  @override
  Widget build ( BuildContext context ) {
    return DefaultTabController (
        length: _tabHeaders.length,
        child: Scaffold (
          appBar: _appBar (),
          drawer: _drawer (),
          body: TabBarView (
              children: _tabPages ()
          ),
        )
    );
  }
}