import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String? category;
  String id;

  String? title;
  String? description;

  double? price;

  List<dynamic>? images;
  List<dynamic>? sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot)
      : id = snapshot.id, // Uso do snapshot.id em vez de snapshot.documentID
        category = (snapshot.data() as Map<String, dynamic>)["category"],
        title = (snapshot.data() as Map<String, dynamic>)["title"],
        description = (snapshot.data() as Map<String, dynamic>)["description"],
        price = (snapshot.data() as Map<String, dynamic>)["price"]?.toDouble(),
        images = (snapshot.data() as Map<String, dynamic>)["images"],
        sizes = (snapshot.data() as Map<String, dynamic>)["sizes"];
}
  // {
  //   id = snapshot.id;
  //   title = snapshot.data["title"];
  //   description =snapshot.data["description"];
  //   price = snapshot.data["price"];
  //   images = snapshot.data["images"];
  //   sizes = snapshot.data["sizes"];

  // }

