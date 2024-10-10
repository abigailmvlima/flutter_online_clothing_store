import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_clothing_store/datas/product_data.dart';

class CartProduct {
  late String cid;

  late String category;
  late String pid;

  late int quantity;
  late String size;

  late ProductData productData;

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;

    final data = document.data() as Map<String, dynamic>;

    category = data["category"] ?? "";
    pid = data["pid"] ?? "";
    quantity = data["quantity"] ?? 1; // Valor padrão como 1
    size = data["size"] ?? "M"; // Valor padrão como "M"
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData.toResumedMap(),
    };
  }
}
