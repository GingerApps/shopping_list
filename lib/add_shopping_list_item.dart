import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/repository/item_repository.dart';
import 'package:shopping_list/repository/shopping_list_repository.dart';

class AddShoppingListItem extends StatelessWidget {
  AddShoppingListItem({Key? key}) : super(key: key);

  final ItemRepository itemRepository = ItemRepository();
  final ShoppingListRepository shoppingListRepository = ShoppingListRepository();

// final List<Item> listOfItems = FirebaseFirestore.instance.collection('items')

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items To Shopping List'),
      ),
      body:
          // ListView.builder(
          //   itemCount: FirebaseFirestore.instance.collection('items').get().,
          //     itemBuilder: (context, snapshot) {
          // })

          StreamBuilder<QuerySnapshot>(
              stream: itemRepository.getStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    child: const LinearProgressIndicator(),
                  );
                }
                return ListView(
                    padding: const EdgeInsets.all(8),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Card(
                        elevation: 10,
                        child: ElevatedButton(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(data['name']),
                            ),
                          ),
                          onPressed: () {

                          },
                        ),
                      );
                    }).toList());
              }),
    );
  }
}
