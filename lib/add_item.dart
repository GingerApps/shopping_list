import 'package:flutter/material.dart';
import 'package:shopping_list/repository/item_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/items.dart';

enum MeasureUnit { pcs, kg }

class AddItemToShoppingList extends StatefulWidget {
  const AddItemToShoppingList({Key? key}) : super(key: key);

  @override
  State<AddItemToShoppingList> createState() => _AddItemToShoppingList();
}

class _AddItemToShoppingList extends State<AddItemToShoppingList> {
  final ItemRepository repository = ItemRepository();
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // length: 3,
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Items To Shopping List'),
          bottom: const TabBar(
            tabs: <Widget>[
              // Tab(text: "Favourite"),
              // Tab(text: 'Per Category'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // _favoriteItems(),
            // const Icon(Icons.ac_unit),
            StreamBuilder<QuerySnapshot>(
                stream: repository.getStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LinearProgressIndicator();
                  }
                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Card(
                        elevation: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            ListTile(
                              leading: const Icon(
                                Icons.add_shopping_cart,
                              ),
                              title: Expanded(
                                child: Row(
                                  children: [
                                    Text(data['name']),
                                    Text(data['measure_unit']),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  editItemDialog(context, document);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                              color: Colors.black,
                            ),
                          ]),
                        ),
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
              displayTextInputDialog(context);
            },
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  void editItemDialog(BuildContext context, DocumentSnapshot snapshot) {
    showDialog<Item>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
        String? itemName = data['name'];
        String? selectedDropdownListItem = data['measure_unit'];
        double? itemQuantity = data['quantity'];
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Form(
            key: _formKey,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      initialValue: itemName,
                      onSaved: (newValue) => itemName,
                    ),
                    DropdownButtonFormField<String>(
                      // hint: const Text(''),
                      decoration: const InputDecoration(
                        labelText: 'Measure Unit',
                      ),
                      // validator: (String? value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter some text';
                      //   }
                      //   return null;
                      // },
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
                  ],
                );
              },
            ),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text("Create"),
                  onPressed: () {
                    if (selectedDropdownListItem != null && itemName != null && itemName.isNotEmpty) {
                      _formKey.currentState?.save();
                      repository.updateItem(Item(itemName, selectedDropdownListItem!, itemQuantity!));
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // Future<void> _displayTextInputDialog(BuildContext context) async {
  //   await showDialog<void>(
  void displayTextInputDialog(BuildContext context) {
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    controller: _textFieldController,
                  ),
                  DropdownButtonFormField<String>(
                    // hint: const Text(''),
                    decoration: const InputDecoration(
                      labelText: 'Measure Unit',
                    ),
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
                ],
              );
            },
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text("Create"),
                  onPressed: () {
                    //TODO add a warning message that a measure unit needs to be selected
                    if (selectedDropdownListItem != null) {
                      repository.addItem(Item(_textFieldController.text, selectedDropdownListItem!, 0));
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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

// Widget _favoriteItems() {
//   return ListView.builder(
//     itemCount: 5,
//     itemBuilder: (context, i) {
//       return const ListTile(
//         title: Text('paok'),
//       );
//     },
//   );
// }
}
