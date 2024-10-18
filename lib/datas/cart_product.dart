import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_clothing_store/datas/product_data.dart';

class CartProduct {
  String? cid; // ID do carrinho (pode ser nulo)
  String? category; // Permite que seja nulo até ser definido
  String? pid; // Permite que seja nulo até ser definido
  int? quantity; // Permite que seja nulo até ser definido
  String? size; // Permite que seja nulo até ser definido
  ProductData? productData; // Permite que seja nulo até ser carregado

  // Construtor padrão
  CartProduct();

  // Construtor que cria um CartProduct a partir de um documento do Firestore
  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id; // Obtém o ID do documento

    final data = document.data() as Map<String, dynamic>;

    // Inicializa os campos do CartProduct com os dados do documento
    category = data["category"];
    pid = data["pid"];
    quantity = data["quantity"];
    size = data["size"];

    // Inicializa productData se estiver presente no documento
    if (data.containsKey('product') && data['product'] != null) {
      productData = ProductData.fromDocument(data['product']);
    }
  }

  // Converte o CartProduct em um mapa para armazenar no Firestore
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      // "product": productData?.toResumedMap(), // Use se precisar salvar os dados do produto também
    };
  }
}
