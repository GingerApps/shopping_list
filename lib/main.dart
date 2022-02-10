import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/add_item.dart';
import 'package:shopping_list/repository/shopping_list_repository.dart';

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
  final ShoppingListRepository shoppingListRepository = ShoppingListRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping List'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: shoppingListRepository.getStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: const LinearProgressIndicator(),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return Card(
                  elevation: 10,
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(documentSnapshot.id);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteProduct(String productId) async {
    await FirebaseFirestore.instance.collection('shopping_list').doc(productId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('You have successfully deleted a product')));
  }

  void _addItem() {
    Navigator.pushNamed(context, '/add');
  }
}
