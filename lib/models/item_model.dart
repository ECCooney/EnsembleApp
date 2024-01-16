import 'package:meta/meta.dart';

class ItemModel {
  final String id;
  final String itemName;
  final String description;

  ItemModel(
      {required this.id,
        required this.itemName,
        required this.description});

  factory ItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String itemName = data['itemName'];
    String description = data['description'];

    return ItemModel(
        id: documentId, itemName: itemName, description: description);
  }

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'description': description,
    };
  }
}