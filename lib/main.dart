import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CurrentShoppingList(),
        '/second': (context) => SecondScreen(),
      },
    );
  }
}

class CurrentShoppingList extends StatefulWidget {
  const CurrentShoppingList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddItemToShoppingList();
}

class _AddItemToShoppingList extends State<CurrentShoppingList> {
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
    Navigator.pushNamed(context, '/second');
  }
}

class SecondScreen extends StatelessWidget {
  final DataRepository repository = DataRepository();
  final TextEditingController _textFieldController = TextEditingController();

  SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Items To Shopping List'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: "Favourite"),
              Tab(text: 'Per Category'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _favoriteItems(),
            const Icon(Icons.ac_unit),
            StreamBuilder<QuerySnapshot>(
              stream: repository.getStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const  LinearProgressIndicator();
                }
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name']),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 60,
          width: 200,
          child: FloatingActionButton(
            child: const Text("Create New Item"),
            onPressed: () {
              _displayTextInputDialog(context);
            },
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            // elevation: ,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {

    return const ListTile(
      title: Text('yo'),
    );

    // return ListTile(
    //   title: Row(
    //     children: [
    //       Expanded(
    //         child: Text(
    //           document["name"],
    //           style: Theme.of(context).textTheme.headline1,
    //         ),
    //       ),
    //       Container(
    //         decoration: const BoxDecoration(
    //           color: Color(0xffddddff),
    //         ),
    //         padding: const EdgeInsets.all(10.0),
    //         child: Text(
    //           document['name'],
    //           style: Theme.of(context).textTheme.bodyText1,
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('TextField in Dialog'),
          content: TextField(
            onChanged: (value) {},
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Text Field in Dialog"),
          ),
        );
      },
    );
  }

  Widget _favoriteItems() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, i) {
        return const ListTile(
          title: Text('paok'),
        );
      },
    );
  }
}
