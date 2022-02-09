import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/models/items.dart';

class ShoppingListRepository {

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('shopping_list');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addItem(Item item) {
    return collection.add(item.toJson());
  }

  void updateItem(Item item) async {
    await collection.doc( item.name).update(item.toJson());
  }

  void deleteItem(Item item) async {
    await collection.doc(item.name).delete();
  }

}
