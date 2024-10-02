import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String? category;
  String id;

  String? title;
  String? description;

  double? price;

  List<dynamic>? images;
  List<dynamic>? size;

  ProductData.fromDocument(DocumentSnapshot snapshot)
      : id = snapshot.id,
        category = (snapshot.data() as Map<String, dynamic>)["category"],
        title = (snapshot.data() as Map<String, dynamic>)["title"],
        description = (snapshot.data() as Map<String, dynamic>)["description"],
        price = (snapshot.data() as Map<String, dynamic>)["price"]?.toDouble(),
        // Adicionando verificação para garantir que o tipo é uma lista
        images = (snapshot.data() as Map<String, dynamic>)["images"] is List
            ? (snapshot.data() as Map<String, dynamic>)["images"]
            : [], // Se não for uma lista, atribui uma lista vazia
        size = (snapshot.data() as Map<String, dynamic>)["size"] is List
            ? (snapshot.data() as Map<String, dynamic>)["size"]
            : []; // Se não for uma lista, atribui uma lista vazia
}
