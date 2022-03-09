import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data_classes.dart';
import '../stubs.dart';

Future <List<Todos>> fetchTodos( int userId ) async {
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

List<Todos> createTodosList (List data) {
  List<Todos> list = [];
  for (int i = 0; i< data.length; i++) {
    Todos? todos = Todos.fromJson( data[i] );
    list.add(todos);
  }
  return list;
}

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Future<List<Todos>> futureTodos;

  ListTile _item (BuildContext context, int index, dynamic snapshot){
    // цвета элементов ListTile
    const TextStyle _completedStyle = TextStyle(color: Colors.green);  //для свойства subtitle
    const TextStyle _titleNameStyle = TextStyle(color: Colors.indigo); //для свойства title

    return ListTile (
        title: Text( snapshot.data![index].title,
            style: _titleNameStyle),
        trailing: snapshot.data![index].completed ?
                  const Icon(Icons.check_box_outlined, size: 16, color: Color.fromRGBO(0, 255, 0, 1.0),)
                  : const Text ("")
    );
  }

  @override
  void initState() {
    super.initState();
    futureTodos = fetchTodosTest(1);//fetchTodos(1); //TODO put userId here
  }

  @override
  Widget build(BuildContext context) {
    final _tabPages = <Widget>[
      ///////////////// users details
      Center(
          child: ListView(
            children: [
              ListTile(title: Text("${widget.user.id}"),subtitle: Text("id"),),
              ListTile(title: Text(widget.user.name),subtitle: Text("name"),),
              ListTile(title: Text(widget.user.username),subtitle: Text("userName"),),
              ListTile(title: Text(widget.user.phone),subtitle: Text("phone"),),
              ListTile(title: Text(widget.user.email),subtitle: Text("e-mail"),),
              ListTile(title: Text(widget.user.website),subtitle: Text("website"),),

            ],
          )
      ),
      /////////////// List Todos
      Center(
          child: FutureBuilder<List<Todos>>(
              future: futureTodos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //print (snapshot.data!);
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
      ),


    ];
    final _tabHeaders = <Tab>[
      const Tab(icon: Icon(Icons.account_box_rounded), text: 'О пользователе'),
      const Tab(icon: Icon(Icons.list), text: 'Задачи'),
    ];
    return DefaultTabController(
        length: _tabHeaders.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Данные пользователя"),//TODO put here username
            backgroundColor: Colors.cyan,
            bottom: TabBar( tabs: _tabHeaders),
          ),
          body: TabBarView(children: _tabPages),
    ));
  }
}
