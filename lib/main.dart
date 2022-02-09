import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/add_item.dart';

import 'add_shopping_list_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBO4Kj3ldVdXjV0RrlmfXCwtVmo3yNFXHI",
      appId: "shopping-list-f4896",
      messagingSenderId: "1094003500336",
      projectId: "shopping-list-f4896",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CurrentShoppingList(),
        '/add': (context) => AddShoppingListItem(),
        '/second': (context) => const AddItemToShoppingList(),
      },
    );
  }
}

class CurrentShoppingList extends StatefulWidget {
  const CurrentShoppingList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CurrentShoppingList();
}

class _CurrentShoppingList extends State<CurrentShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping List'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          Text('1'),
          Text('2'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem() {
    Navigator.pushNamed(context, '/add');
  }
}

