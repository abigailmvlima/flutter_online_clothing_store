import 'package:flutter/material.dart';
import 'package:online_clothing_store/models/cart_model.dart';
import 'package:online_clothing_store/models/user_model.dart';
import 'package:online_clothing_store/screens/login_screen.dart';
import 'package:online_clothing_store/tiles/cart_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, userModel) {
        // Verifica se o UserModel está disponível
        return ScopedModel<CartModel>(
          model: CartModel(userModel), // Passa o UserModel para o CartModel
          child: Scaffold(
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
                        style: const TextStyle(
                            fontSize: 17.0, color: Colors.white),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
              if (model.isLoading && userModel.isLoggedIn()) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!userModel.isLoggedIn()) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.remove_shopping_cart,
                        size: 80.0,
                        color: Color.fromARGB(255, 211, 118, 130),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Faça o login para adicionar produtos!",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 211, 118, 130),
                        ),
                        child: const Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
                // ignore: unnecessary_null_comparison
              } else if (model.products == null || model.products.isEmpty) {
                return const Center(
                  child: Text(
                    "Seu carrinho está vazio!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: model.products.length,
                  itemBuilder: (context, index) {
                    final product = model.products[index];
                    return CartTile(
                      cartProduct: product,
                    );
                  },
                );
              }
            }),
          ),
        );
      },
    );
  }
}
