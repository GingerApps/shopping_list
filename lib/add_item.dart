import 'package:flutter/material.dart';
import 'package:shopping_list/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/items.dart';

enum MeasureUnit { pcs, kg }

class AddItemToShoppingList extends StatefulWidget {
  const AddItemToShoppingList({Key? key}) : super(key: key);

  @override
  State<AddItemToShoppingList> createState() => _AddItemToShoppingList();
}

class _AddItemToShoppingList extends State<AddItemToShoppingList> {
  final DataRepository repository = DataRepository();
  final TextEditingController _textFieldController = TextEditingController();

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
                    return const LinearProgressIndicator();
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name']),
                      );
                    }).toList(),
                  );
                }),
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
          ),
        ),
      ),
    );
  }

  // Future<void> _displayTextInputDialog(BuildContext context) async {
  //   await showDialog<void>(
  void _displayTextInputDialog(BuildContext context) {
    showDialog<Item>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? selectedDropdownListItem;
        return AlertDialog(
          title: const Text('Create a new Item'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _textFieldController,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton<String>(
                      hint: const Text("Pick a thing"),
                      value: selectedDropdownListItem,
                      onChanged: (String? value) {
                        setState(() {
                          selectedDropdownListItem = value;
                        });
                      },
                      items: <String>['Kg', 'Pcs'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    repository.addItem(Item(_textFieldController.text, selectedDropdownListItem!));
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {},
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  //   return const ListTile(
  //     title: Text('yo'),
  //   );
  // }

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