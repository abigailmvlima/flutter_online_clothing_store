import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:online_clothing_store/datas/cart_product.dart';
import 'package:online_clothing_store/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  final Logger _logger = Logger();

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  // Adicionar item ao carrinho
  void addCartItem(CartProduct cartProduct) async {
    products.add(cartProduct);

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.firebaseUser?.uid)
          .collection("cart")
          .add(cartProduct.toMap());

      cartProduct.cid = docRef.id; // Atualiza o ID do produto
      notifyListeners(); // Notifica após o sucesso da operação
    } catch (error) {
      _logger.e("Erro ao adicionar produto ao carrinho: $error");
    }
  }

  // Remover item do carrinho
  void removeCartItem(CartProduct cartProduct) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.firebaseUser?.uid)
          .collection("cart")
          .doc(cartProduct.cid)
          .delete();

      products.remove(cartProduct);
      notifyListeners(); // Notificar após remoção bem-sucedida
    } catch (error) {
      _logger.e("Erro ao remover produto do carrinho: $error");
    }
  }

  // Diminuir quantidade do produto
  void decProduct(CartProduct cartProduct) async {
    if ((cartProduct.quantity ?? 1) > 1) {
      // Garante que quantity não seja null, usa 1 como fallback
      cartProduct.quantity = (cartProduct.quantity ?? 1) -
          1; // Subtrai 1, garantindo que quantity não seja null

      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.firebaseUser?.uid)
            .collection("cart")
            .doc(cartProduct.cid)
            .update(cartProduct.toMap());

        notifyListeners(); // Notifica após a operação bem-sucedida
      } catch (error) {
        _logger.e("Erro ao diminuir quantidade: $error");
      }
    }
  }

  // Aumentar quantidade do produto
  void inProduct(CartProduct cartProduct) async {
    cartProduct.quantity = (cartProduct.quantity ?? 0) +
        1; // Adiciona 1, garantindo que quantity não seja null

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.firebaseUser?.uid)
          .collection("cart")
          .doc(cartProduct.cid)
          .update(cartProduct.toMap());

      notifyListeners(); // Notifica após a operação bem-sucedida
    } catch (error) {
      _logger.e("Erro ao aumentar quantidade: $error");
    }
  }

  // Carregar os itens do carrinho do Firestore
  void _loadCartItems() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.firebaseUser?.uid)
          .collection("cart")
          .get();

      products =
          query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
      notifyListeners(); // Notifica após carregar os itens
    } catch (error) {
      _logger.e("Erro ao carregar itens do carrinho: $error");
    }
  }
}
