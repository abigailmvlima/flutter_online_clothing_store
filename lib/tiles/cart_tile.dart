import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_clothing_store/datas/cart_product.dart';
import 'package:online_clothing_store/datas/product_data.dart';
import 'package:online_clothing_store/models/cart_model.dart';

class CartTile extends StatelessWidget {
  const CartTile({super.key, required this.cartProduct});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Widget _buildContent() {
      return Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              (cartProduct.productData?.images != null &&
                      cartProduct.productData!.images!.isNotEmpty)
                  ? cartProduct
                      .productData!.images![0] // Usa a primeira imagem da lista
                  : '', // Se não houver imagens, usa string vazia
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  cartProduct.productData?.title ??
                      '', // Título do produto (pode ser nulo)
                  style: const TextStyle(
                      fontSize: 17.0, fontWeight: FontWeight.w500),
                ),
                const Text("Tamanho",
                    style: TextStyle(fontWeight: FontWeight.w300)),
                Text(
                    "R\$ ${cartProduct.productData?.price?.toStringAsFixed(2) ?? '0.00'}", // Exibe o preço formatado
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: cartProduct.quantity! > 1
                          ? () {
                              CartModel.of(context).decProduct(cartProduct);
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      onPressed: () {
                        CartModel.of(context).inProduct(cartProduct);
                      },
                      icon: const Icon(Icons.add),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                      child: Text(
                        "Remover",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(cartProduct.category)
                  .collection("items")
                  .doc(cartProduct.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cartProduct.productData =
                      ProductData.fromDocument(snapshot.data!);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70.0,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
