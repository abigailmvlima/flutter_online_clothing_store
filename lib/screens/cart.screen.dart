import 'package:flutter/material.dart';
import 'package:online_clothing_store/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 211, 118, 130),
          title: const Text(
            'Meu carrinho',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 8.0),
              alignment: Alignment.center,
              child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                int p = model.products.length;
                return Text(
                  "$p ${p == 1 ? "ITEM" : "ITENS"}",
                  style: const TextStyle(fontSize: 17.0, color: Colors.white),
                );
              }),
            ),
          ]),
    );
  }
}
