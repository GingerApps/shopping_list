import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/repository/item_repository.dart';
import 'package:shopping_list/repository/shopping_list_repository.dart';

class AddShoppingListItem extends StatelessWidget {
  AddShoppingListItem({Key? key}) : super(key: key);

  final ItemRepository itemRepository = ItemRepository();
  final ShoppingListRepository shoppingListRepository = ShoppingListRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items To Shopping List'),
      ),
      body:
          //         ListView.builder(
          //           itemCount: FirebaseFirestore.instance.collection("items").get().then((querySnapshot) {
          // querySnapshot.docs.length;}),
          //             itemBuilder: (context, snapshot) {
          //         })
          StreamBuilder(
              stream: itemRepository.getStream(),
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
                      child: ElevatedButton(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(documentSnapshot['name']),
                          ),
                        ),
                        onPressed: () {
                          _createOrUpdate(documentSnapshot);
                        },
                      ),
                    );
                  },
                );
              }),
    );
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    await FirebaseFirestore.instance.collection("shopping_list").add({"name": documentSnapshot!['name']});
  }

}
